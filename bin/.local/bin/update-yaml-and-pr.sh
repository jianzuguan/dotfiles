#!/bin/bash

# Script to update a YAML field and create a pull request
# Usage: ./update-yaml-and-pr.sh <yaml_file> <field_path> <new_value> [branch_name] [pr_title]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required arguments are provided
if [ $# -lt 3 ]; then
    print_error "Usage: $0 <repo_root> <yaml_file> <field_path> <new_value> [branch_name] [pr_title]"
    echo ""
    echo "Examples:"
    echo "  $0 ~/projects/kmi-services services/exception-management/oea/service.oea-test.yaml exception-management.application.image.tag abc123"
    echo "  $0 ~/projects/kmi-services services/exception-management/oea/service.oea-test.yaml exception-management.application.image.tag abc123 'update-tag-abc123' 'Update exception-management tag to abc123'"
    exit 1
fi

REPO_ROOT="$1"
YAML_FILE="$2"
FIELD_PATH="$3"
NEW_VALUE="$4"
BRANCH_NAME="${5:-update-$(basename "$YAML_FILE" .yaml)-$(date +%Y%m%d-%H%M%S)}"
PR_TITLE="${6:-Update $FIELD_PATH to $NEW_VALUE}"

# Move to the repository root
cd "$REPO_ROOT" || { print_error "Could not change directory to $REPO_ROOT"; exit 1; }

# Check if file exists
if [ ! -f "$YAML_FILE" ]; then
    print_error "File not found: $YAML_FILE"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    print_error "yq is not installed. Please install it first."
    echo "macOS: brew install yq"
    echo "Linux: sudo snap install yq"
    echo "Or visit: https://github.com/mikefarah/yq"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first."
    echo "Visit: https://cli.github.com/"
    exit 1
fi

# Check if authenticated with GitHub CLI
if ! gh auth status &> /dev/null; then
    print_error "Not authenticated with GitHub CLI. Please run 'gh auth login' first."
    exit 1
fi

print_status "Starting YAML update and PR creation process..."

# Get current branch
ORIGINAL_BRANCH=$(git branch --show-current)
print_status "Current branch: $ORIGINAL_BRANCH"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes. They will not be included in the PR."
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Aborted"
        exit 0
    fi
fi

# Stash changes if any
if ! git diff-index --quiet HEAD --; then
    print_status "Stashing uncommitted changes..."
    git stash push -m "Stash before updating YAML field"
    STASHED=true
else
    STASHED=false
fi

# Change to main branch if not already on it
if [ "$ORIGINAL_BRANCH" != "main" ]; then
    print_status "Switching to main branch..."
    git checkout main || { print_error "Failed to switch to main branch"; exit 1; }
fi

# Pull latest changes from main
print_status "Pulling latest changes from main branch..."
git pull origin main || { print_error "Failed to pull latest changes from main branch"; exit 1; }

# Show current value
print_status "Getting current value of $FIELD_PATH..."
CURRENT_VALUE=$(yq eval ".$FIELD_PATH" "$YAML_FILE" 2>/dev/null)

if [ "$CURRENT_VALUE" != "null" ] && [ -n "$CURRENT_VALUE" ]; then
    print_status "Current value: $CURRENT_VALUE"
    if [ "$CURRENT_VALUE" = "$NEW_VALUE" ]; then
        print_warning "Current value is already $NEW_VALUE. No changes needed."
        exit 0
    fi
else
    print_warning "Could not retrieve current value or field does not exist"
    CURRENT_VALUE="<not set>"
fi

# Create and switch to new branch
print_status "Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Update the YAML file
print_status "Updating YAML file..."
if yq eval ".$FIELD_PATH = \"$NEW_VALUE\"" -i "$YAML_FILE"; then
    print_success "YAML file updated successfully"
else
    print_error "Failed to update YAML file"
    git checkout "$ORIGINAL_BRANCH"
    git branch -D "$BRANCH_NAME"
    exit 1
fi

# Check if there are changes to commit
if git diff-index --quiet HEAD --; then
    print_warning "No changes detected after update"
    git checkout "$ORIGINAL_BRANCH"
    git branch -D "$BRANCH_NAME"
    exit 0
fi

# Show the diff
print_status "Changes made:"
git diff --color=always

# Commit changes
COMMIT_MESSAGE="Update $FIELD_PATH to $NEW_VALUE

- Updated field: $FIELD_PATH
- Previous value: $CURRENT_VALUE
- New value: $NEW_VALUE
- File: $YAML_FILE"

print_status "Committing changes..."
git add "$YAML_FILE"
git commit -m "$COMMIT_MESSAGE"

# Push branch
print_status "Pushing branch to origin..."
git push -u origin "$BRANCH_NAME"

# Create pull request
print_status "Creating pull request..."
PR_BODY="## Description

Deploy exception-management service in $YAML_FILE with tag $NEW_VALUE

## Who should review this PR?

> [!IMPORTANT]
> [Codeowners](https://github.com/kaluza-platform/kmi-services/blob/main/.github/CODEOWNERS) of the files that have been changed are solely responsible for reviewing the PR. It's very important that Terraform plan outputs on the PR are checked by both the author and reviewers to ensure they are as expected, before approval and merge.

You may see a warning when Terraform suggests resources will be deleted in a plan:

> [!WARNING]
> 🧨 &nbsp; Resources are destroyed by this change, please check the `plan` / `apply` output.

Please do not depend on this when reviewing; Terraform plans should always be thoroughly checked on each PR and treated as the source of truth for expected changes.

## How To Get Help

If you see anything unusual in Terraform plan outputs, or just want a second review/opinion for reassurance please talk to us in [#ask-kmi](https://kaluza.enterprise.slack.com/archives/C058P4G9Z1C); otherwise teams should be self-sufficient in the majority of PRs."

PR_URL=$(gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base "$ORIGINAL_BRANCH")

print_success "Pull request created: $PR_URL"

# Switch back to original branch
git checkout "$ORIGINAL_BRANCH"

print_success "Process completed successfully!"
echo ""
echo "Summary:"
echo "  - Branch created: $BRANCH_NAME"
echo "  - File updated: $YAML_FILE"
echo "  - Field updated: $FIELD_PATH ($CURRENT_VALUE → $NEW_VALUE)"
echo "  - Pull request: $PR_URL"
