{
  requiredProvider(name, source, version): {
    _manifest():: self,
    terraform+: {
      required_providers+: {
        [name]: {
          source: source,
          version: version,
        },
      },
    },
  },

  importResource(resource, id):
    local blockType = std.objectFields(resource)[0];
    local resourceType = std.objectFields(resource[blockType])[0];
    local key = resource.tf_resource_key;
    {
      _manifest():: self,
      'import'+: [{
        to: std.join('.', [resourceType, key]),
        id: id,
      }],
    },

  withDynamicBlock(key, foreach, content): {
    dynamic+: {
      [key]: {
        for_each: foreach,
        content: content,
      },
    },
  },

  ref(resource, field):
    local blockType = std.objectFields(resource)[0];
    local resourceType = std.objectFields(resource[blockType])[0];
    local key = resource.tf_resource_key;
    '${%s}' % std.join(
      '.',
      (if blockType == 'resource'
       then []
       else [blockType])
      + (if std.member(['resource', 'data', 'ephemeral'], blockType)
         then [resourceType]
         else [])
      + [key, field]
    ),
}
