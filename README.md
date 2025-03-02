# soysonnet

Jsonnet libraries to generate libraries and resources for Hashicorp's Terraform.

## What is this?

- `soy-gen` can convert Terraform provider schemas into JSON schemas and generate Jsonnet libraries.
- `soy-common` provides common utility functions to work with the generated libraries.

## Why?

Because it is fun... :)

Jsonnet is my go-to tooling to configure applications in Kubernetes but I needed something to manage the more low level resources that come *before* Kubernetes. Terraform is the de facto standard in this space, thus I wrote this generator so I could use the same language (jsonnet) to configure all my CSP resources.

## How?

This tool builds upon [crdsonnet], which uses JSON schemas to generate Jsonnet code with [astsonnet]. However Terraform doesn't distribute [JSON Schemas] for the providers so I wrote a converter to aid in this. The converter builds upon docs and assumptions, so there may still be some mistakes there.

[crdsonnet]: https://github.com/crdsonnet/crdsonnet
[astsonnet]: https://github.com/crdsonnet/astsonnet
[JSON Schemas]: https://json-schema.org/
