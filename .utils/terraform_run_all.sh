#!/bin/bash

TAG=latest
for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
    rm -rf "$f/provider.tf"
    rm -rf "$f/.terraform"
    rm -rf "$f/.terraform.lock.hcl"
    cp ".utils/provider.tf" "$f/"
    cd "$f"
    docker run -v "$(pwd)":/tmp -w /tmp hashicorp/terraform:$TAG "$1"    
    cd ..
  fi
done
