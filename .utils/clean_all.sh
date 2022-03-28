#!/bin/bash

for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
    rm -rf "$f/ignore_provider.tf"
    rm -rf "$f/.terraform"
    rm -rf "$f/.tfsec"
    rm -rf "$f/.terraform.lock.hcl"
  fi
done
