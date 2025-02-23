// This library provides functions to convert Terraform provider schemas into JSON schemas. The Terraform provider schemas can be generated with `terraform providers schema -json`.
//
// > [!CAUTION]
// > This is an experimental library.
{
  local root = self,
  local convert = import './convert.libsonnet',
  local generator = import './generate.jsonnet',

  local defaultFilterFn(_) = true,
  local defaultGroupFn(key) = std.split(key, '_')[1],

  // Returns an object with functions to convert resource schemas into JSON schemas and generate Jsonnet libraries.
  //
  // This example generates resources libraries for the AWS provider:
  //
  // ```jsonnet
  // // generator.jsonnet
  // local soy = import 'github.com/Duologic/soysonnet/main.libsonnet';
  //
  // local aws =
  //   soy.new(
  //     name='aws',
  //     source='registry.terraform.io/hashicorp/aws',
  //     version='5.87.0',
  //     schema=import 'tfschema.json'
  //   );
  //
  // aws.provider.generateLibrary()
  // + aws.resource.generateLibraries()
  // ```
  // Then execute it like this:
  //
  // ```console
  // jsonnet -S -m output -c -J vendor generator.jsonnet | jsonnetfmt -i
  // ```
  new(name, source, version, schema): {
    local providerSchema = schema.provider_schemas[source],

    provider: {
      // Get JSON schema
      getSchema():
        convert.providerSchema(name, providerSchema.provider),
      // Generate library from `schema`
      generateLibrary(schema=self.getSchema()): {
        'provider.libsonnet':
          generator.generateProviderLibrary(schema),
      },
    },

    resource: {
      // Get JSON schema for resource blocks
      //
      // PARAMETERS:
      //   - **filterFn** (`function`): fn(<resourceType>(`string`)) `bool`
      //     Filter out to include/exclude specific resources.
      //   - **groupFn** (`function`): fn(<resourceType>(`string`)) `string`
      //     Returns a key under which the resources will be grouped. By default it'll split the resource type by `_` and return the second word, for example: `aws_route53_record` will be grouped under `route53`.
      getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
        root.getSchemas(
          providerSchema,
          'resource_schemas',
          convert.resourceSchema,
          filterFn,
          groupFn,
        ),
      // Generate library from `schemas`
      generateLibraries(schemas=self.getSchemas()): {
        ['resource/' + group.key + '.libsonnet']:
          generator.generateResourceLibrary(group.value, group.key, 'resource')
        for group in std.objectKeysValues(schemas)
      },
    },

    ephemeral: {
      // Get JSON schema for ephemeral resource blocks
      //
      // PARAMETERS: *see `resource.getSchemas()`*
      getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
        root.getSchemas(
          providerSchema,
          'ephemeral_resource_schemas',
          convert.ephemeralResourceSchema,
          filterFn,
          groupFn,
        ),
      // Generate library from `schemas`
      generateLibraries(schemas=self.getSchemas()): {
        ['ephemeral/' + group.key + '.libsonnet']:
          generator.generateResourceLibrary(group.value, group.key, 'ephemeral')
        for group in std.objectKeysValues(schemas)
      },
    },

    data: {
      // Get JSON schema for datasource blocks
      //
      // PARAMETERS: *see `resource.getSchemas()`*
      getSchemas(filterFn=defaultFilterFn, groupFn=defaultGroupFn):
        root.getSchemas(
          providerSchema,
          'data_source_schemas',
          convert.dataSourceSchema,
          filterFn,
          groupFn,
        ),
      // Generate library from `schemas`
      generateLibraries(schemas=self.getSchemas()): {
        ['data/' + group.key + '.libsonnet']:
          generator.generateResourceLibrary(group.value, group.key, 'data')
        for group in std.objectKeysValues(schemas)
      },
    },
  },

  getSchemas(providerSchema, key, convertFn, filterFn=defaultFilterFn, groupFn=defaultGroupFn)::
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
