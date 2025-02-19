function(
  name,
  source,
  version,
) {
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
}
