#!/bin/bash

TAG=latest
for f in *; do
  if [ -d "$f" ]; then
    echo "$f"
<<<<<<< HEAD
    cp ".utils/provider.tf" "$f/"
=======
>>>>>>> 6572bc7 (Add init for tf validate (#165))
    cd "$f"
    docker run -v $(pwd):/tmp -w /tmp hashicorp/terraform:$TAG $1
    cd ..
  fi
done