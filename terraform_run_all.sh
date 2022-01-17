#!/bin/bash

TAG=latest
for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
    cd "$f"
    docker run -v $(pwd):/tmp -w /tmp hashicorp/terraform:$TAG $1
    cd ..
  fi
done
