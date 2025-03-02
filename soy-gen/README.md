# soy-gen

This library provides functions to convert Terraform provider schemas into JSON schemas and generate Jsonnet libraries.
The Terraform provider schemas can be generated with `terraform providers schema -json`.

> [!CAUTION]
> This is an experimental library.

## Functions

### func new

```jsonnet
new(name, source, version, schema)
```

Returns functions get the JSON schemas and generate Jsonnet libraries.

This example generates resources libraries for the AWS provider:

```jsonnet
// generator.jsonnet
local soy = import 'github.com/Duologic/soysonnet/main.libsonnet';

local aws =
  soy.new(
    name='aws',
    source='registry.terraform.io/hashicorp/aws',
    version='5.87.0',
    schema=import 'tfschema.json'
  );

aws.provider.generateLibrary()
+ aws.resource.generateLibraries()
```
Then execute it like this:

```console
jsonnet -S -m output -c -J vendor generator.jsonnet | jsonnetfmt -i
```

#### obj new().provider

```jsonnet
getSchema()
```

Get JSON schema

```jsonnet
generateLibrary(schema=self.getSchema())
```

Generate library from `schema`

#### obj new().resource

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for resource blocks

PARAMETERS:
  - **filterFn** (`function`): fn(<resourceType>(`string`)) `bool`
    Filter out to include/exclude specific resources.
  - **groupFn** (`function`): fn(<resourceType>(`string`)) `string`
    Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

#### obj new().ephemeral

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for ephemeral resource blocks

PARAMETERS: *see `resource.getSchemas()`*

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

#### obj new().data

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for datasource blocks

PARAMETERS: *see `resource.getSchemas()`*

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

