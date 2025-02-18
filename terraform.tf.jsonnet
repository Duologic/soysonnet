function(
  name='aws',
  source='registry.terraform.io/hashicorp/aws',
  version='5.87.0',
) {
  'terraform.tf.json': std.manifestJson({
    terraform: {
      required_version: '>=v1.10.2',
      required_providers: {
        [name]: {
          source: source,
          version: version,
        },
      },
    },
  }),
}
