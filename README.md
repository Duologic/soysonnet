# soysonnet

## Functions

### func new

```jsonnet
new(name, source, version, schema)
```

Instantiate a new converter

#### obj new()

Instantiate a new converter

##### func new().getDataSourceSchemas

```jsonnet
new().getDataSourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for datasource blocks

PARAMETERS: see `getResourceSchemas()`

##### func new().getEphemeralResourceSchemas

```jsonnet
new().getEphemeralResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for ephemeral resource blocks

PARAMETERS: see `getResourceSchemas()`

##### func new().getProviderSchema

```jsonnet
new().getProviderSchema()
```

get JSON schema for the provider block

##### func new().getResourceSchemas

```jsonnet
new().getResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for resource blocks

PARAMETERS:
  - *filterFn* (`function`): fn(resourceType (`string`)) `bool`
    Filter out to include/exclude specific resources.
  - *groupFn* (`function`): fn(resourceType (`string`)) `string`
    Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.

