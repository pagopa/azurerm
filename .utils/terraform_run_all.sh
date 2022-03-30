#!/bin/bash

TAG=$(cat .terraform-version)
ACTION="$1"
MODE="$2"

for folder in *; do
  if [ -d "$folder" ]; then
    echo "🔬 folder: $folder in under terraform: $ACTION action $MODE mode"

    rm -rf "$folder/.ignore_features.tf"
    rm -rf "$folder/.terraform"
    rm -rf "$folder/.terraform.lock.hcl"
    cp ".utils/features.tf" "$folder/ignore_features.tf"

    cd "$folder" || exit

    case "${MODE}" in
      docker*)
        docker run -v "$(pwd):/tmp" -w /tmp "hashicorp/terraform:$TAG" "$ACTION"
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
