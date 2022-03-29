#!/bin/bash

COMMAND=${3}
MODE=${2}
TAG=${3}


for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
    rm -rf "$f/.ignore_features.tf"
    rm -rf "$f/.terraform"
    rm -rf "$f/.terraform.lock.hcl"
    cp ".utils/features.tf" "$f/ignore_features.tf"
    cd "$f"

    case "${MODE}" in
      docker*)
        docker run -v "$(pwd)":/tmp -w /tmp hashicorp/terraform:"$TAG" "$COMMAND"
      ;;
      local*)
        terraform "$1"
      ;;
    *)
      exit 1
    esac

    cd ..
  fi
done
