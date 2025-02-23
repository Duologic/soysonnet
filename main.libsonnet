// This library provides functions to convert Terraform provider schemas into JSON schemas. The Terraform provider schemas can be generated with `terraform providers schema -json`.
//
// > [!CAUTION]
// > This is an experimental library.
{
  local root = self,
  local convert = import './convert.libsonnet',

  // Returns functions that convert resource schemas into JSON schemas
  //
  // This example gets the schemas for the AWS provider and route53 resources:
  //
  // ```jsonnet
  // local soy = import 'github.com/Duologic/soysonnet/main.libsonnet';
  // local aws =
  //   soy.new(
  //     name='aws',
  //     source='registry.terraform.io/hashicorp/aws',
  //     version='5.87.0',
  //     schema=import 'tfschema.json'
  //   );
  // {
  //   provider:
  //     aws.getProviderSchema(),
  //   resource:
  //     aws.getResourceSchemas(
  //       function(key)
  //         std.startsWith(key, 'aws_route53')
  //     ),
  // }
  // ```
  new(name, source, version, schema): {
    local providerSchema = schema.provider_schemas[source],

    // get JSON schema for the provider block
    getProviderSchema():
      convert.providerSchema(name, providerSchema.provider),

    local defaultFilterFn(_) = true,
    local defaultGroupFn(key) = std.split(key, '_')[1],

    // get JSON schema for resource blocks
    //
    // PARAMETERS:
    //   - **filterFn** (`function`): fn(<resourceType>(`string`)) `bool`
    //     Filter out to include/exclude specific resources.
    //   - **groupFn** (`function`): fn(<resourceType>(`string`)) `string`
    //     Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.
    getResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
      self.getSchemas(
        'resource_schemas',
        convert.resourceSchema,
        filterFn,
        groupFn=defaultGroupFn
      ),

    // get JSON schema for ephemeral resource blocks
    //
    // PARAMETERS: *see `getResourceSchemas()`*
    getEphemeralResourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
      self.getSchemas(
        'ephemeral_resource_schemas',
        convert.ephemeralResourceSchema,
        filterFn,
        groupFn=defaultGroupFn
      ),

    // get JSON schema for datasource blocks
    //
    // PARAMETERS: *see `getResourceSchemas()`*
    getDataSourceSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
      self.getSchemas(
        'data_source_schemas',
        convert.dataSourceSchema,
        filterFn,
        groupFn=defaultGroupFn
      ),

    getSchemas(key, convertFn, filterFn=defaultFilterFn, groupFn=defaultGroupFn)::
      std.foldl(
        function(acc, item)
          if filterFn(item.key)
          then
            assert std.trace(item.key, true);
            acc + { [groupFn(item.key)]+: convertFn(item.key, item.value) }
          else acc,
        std.objectKeysValues(std.get(providerSchema, key, {})),
        {}
      ),
  },

  requiredProvider(name, source, version):: {
    'terraform.tf.json': std.manifestJson({
      terraform: {
        required_providers: {
          [name]: {
            source: source,
            version: version,
          },
        },
      },
    }),
  },
}
