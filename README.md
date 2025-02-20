# soysonnet

This library provides functions to convert Terraform provider schemas into JSON schemas. The Terraform provider schemas can be generated with `terraform providers schema -json`.

> [!CAUTION]
> This is an experimental library.

## Functions

### func new

```jsonnet
new(name, source, version, schema)
```

Returns functions that convert resource schemas into JSON schemas

This example gets the schemas for the AWS provider and route53 resources:

```jsonnet
local soy = import 'github.com/Duologic/soysonnet/main.libsonnet';
local aws =
  soy.new(
    name='aws',
    source='registry.terraform.io/hashicorp/aws',
    version='5.87.0',
    schema=import 'tfschema.json'
  );
{
  provider:
    aws.getProviderSchema(),
  resource:
    aws.getResourceSchemas(
      function(key)
        std.startsWith(key, 'aws_route53')
    ),
}
```

```jsonnet
getProviderSchema()
```

get JSON schema for the provider block

```jsonnet
getResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for resource blocks

PARAMETERS:
  - **filterFn** (`function`): fn(<resourceType>(`string`)) `bool`
    Filter out to include/exclude specific resources.
  - **groupFn** (`function`): fn(<resourceType>(`string`)) `string`
    Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.

```jsonnet
getEphemeralResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for ephemeral resource blocks

PARAMETERS: *see `getResourceSchemas()`*

```jsonnet
getDataSourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn)
```

get JSON schema for datasource blocks

PARAMETERS: *see `getResourceSchemas()`*

