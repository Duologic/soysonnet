#!/usr/bin/env bash
set -euo pipefail

NAME='aws'
SOURCE='registry.terraform.io/hashicorp/aws'
VERSION='5.87.0'

mkdir -p schemas/${NAME}
mkdir -p .build
cd .build

jrsonnet -S -m . \
    -A name=${NAME} \
    -A source=${SOURCE} \
    -A version=${VERSION} \
    ../terraform.tf.jsonnet

terraform init
terraform providers schema -json | jsonnet - > schema.json

jrsonnet -S -m ../schemas/${NAME} \
    -A name=${NAME} \
    -A source=${SOURCE} \
    -A version=${VERSION} \
    --tla-code-file schema='./schema.json' \
    -e "(import '../main.libsonnet').fileOutput"
