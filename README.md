# soysonnet

This library provides functions to convert Terraform provider schemas into JSON schemas. The Terraform provider schemas can be generated with `terraform providers schema -json`.

> [!CAUTION]
> This is an experimental library.

## Functions

### func new

```jsonnet
new(name, source, version, schema)
```

returns functions that convert resource schemas into JSON schemas

```jsonnet
getDataSourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for datasource blocks

PARAMETERS: see `getResourceSchemas()`

```jsonnet
getEphemeralResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for ephemeral resource blocks

PARAMETERS: see `getResourceSchemas()`

```jsonnet
getProviderSchema()
```

get JSON schema for the provider block

```jsonnet
getResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for resource blocks

PARAMETERS:
  - *filterFn* (`function`): fn(resourceType (`string`)) `bool`
    Filter out to include/exclude specific resources.
  - *groupFn* (`function`): fn(resourceType (`string`)) `string`
    Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.

