#!/usr/bin/env bash
set -euo pipefail

NAME='aws'
SOURCE='registry.terraform.io/hashicorp/aws'
VERSION='5.87.0'

mkdir -p schemas/
mkdir -p .build
cd .build

jrsonnet -S -m . \
    -A name=${NAME} \
    -A source=${SOURCE} \
    -A version=${VERSION} \
    ../../terraform.tf.jsonnet

terraform init
terraform providers schema -json | jsonnet - > schema.json

jrsonnet -S -c -m ../schemas \
    -A name=${NAME} \
    -A source=${SOURCE} \
    -A version=${VERSION} \
    --tla-code-file schema='./schema.json' \
    -e "(import '../main.libsonnet').new"
