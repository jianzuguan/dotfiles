#!/bin/bash

./update-yaml-and-pr.sh \
  ~/projects/kmi-services \
  services/exception-management/oea/service.oea-test.yaml \
  exception-management.application.image.tag \
  $1 \
  "deploy-exception-management-tag-to-$1" \
  "Deploy exception-management with tag $1"
