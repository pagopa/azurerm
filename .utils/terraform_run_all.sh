#!/bin/bash

TAG=latest
unameOut="$(uname -s)"

for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
    rm -rf "$f/.provider.tf"
    rm -rf "$f/.terraform"
    rm -rf "$f/.terraform.lock.hcl"
    cp ".utils/provider.tf" "$f/ignore_provider.tf"
    cd "$f"

    case "${unameOut}" in
      Linux*)
        docker run -v "$(pwd)":/tmp -w /tmp hashicorp/terraform:$TAG "$1"
      ;;
      Darwin*)
        terraform "$1"
      ;;
    *)
      exit 1
    esac

    cd ..
  fi
done
