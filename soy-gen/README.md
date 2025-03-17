# soy-gen

This library provides functions to convert Terraform provider schemas into JSON schemas and generate Jsonnet libraries.
The Terraform provider schemas can be generated with `terraform providers schema -json`.

> [!CAUTION]
> This is an experimental library.

## Index

* [func new](#func-new)
  * [obj new().provider](#obj-newprovider)
    * [func new().provider.getSchema](#func-newprovidergetschema)
    * [func new().provider.generateLibrary](#func-newprovidergeneratelibrary)
  * [obj new().resource](#obj-newresource)
    * [func new().resource.getSchemas](#func-newresourcegetschemas)
    * [func new().resource.generateLibraries](#func-newresourcegeneratelibraries)
  * [obj new().ephemeral](#obj-newephemeral)
    * [func new().ephemeral.getSchemas](#func-newephemeralgetschemas)
    * [func new().ephemeral.generateLibraries](#func-newephemeralgeneratelibraries)
  * [obj new().data](#obj-newdata)
    * [func new().data.getSchemas](#func-newdatagetschemas)
    * [func new().data.generateLibraries](#func-newdatageneratelibraries)

## Fields

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

##### func new().provider.getSchema

```jsonnet
getSchema()
```

Get JSON schema

##### func new().provider.generateLibrary

```jsonnet
generateLibrary(schema=self.getSchema())
```

Generate library from `schema`

#### obj new().resource

##### func new().resource.getSchemas

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for resource blocks

PARAMETERS:
  - **filterFn** (`function`): fn(<resourceType>(`string`)) `bool`
    Filter out to include/exclude specific resources.
  - **groupFn** (`function`): fn(<resourceType>(`string`)) `string`
    Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.

##### func new().resource.generateLibraries

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

#### obj new().ephemeral

##### func new().ephemeral.getSchemas

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for ephemeral resource blocks

PARAMETERS: *see `resource.getSchemas()`*

##### func new().ephemeral.generateLibraries

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

#### obj new().data

##### func new().data.getSchemas

```jsonnet
getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

Get JSON schema for datasource blocks

PARAMETERS: *see `resource.getSchemas()`*

##### func new().data.generateLibraries

```jsonnet
generateLibraries(schemas=self.getSchemas())
```

Generate library from `schemas`

