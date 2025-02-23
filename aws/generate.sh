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
    -e "(import '../../main.libsonnet').requiredProvider"

terraform init
terraform providers schema -json | jsonnet - > schema.json

rm -rf ../schemas/*
jrsonnet -S -c -m ../lib \
    -J ../vendor \
    -A name=${NAME} \
    -A source=${SOURCE} \
    -A version=${VERSION} \
    --tla-code-file schema='./schema.json' \
    -e "(import '../main.libsonnet').new"

find ../lib/ -type f | xargs jsonnetfmt -i
