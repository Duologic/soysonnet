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

  getBlockResourceKey(resource):
    local m = resource._manifest();
    {
      block: std.objectFields(m)[0],
      resource: std.objectFields(m[self.block])[0],
      key: std.objectFields(m[self.block][self.resource])[0],
    },

  importResource(resource, id):
    local brk = self.getBlockResourceKey(resource);
    {
      _manifest():: self,
      'import'+: [{
        to: std.join('.', [brk.resource, brk.key]),
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
    local brk = self.getBlockResourceKey(resource);
    '${%s}' % std.join(
      '.',
      (if brk.block == 'resource'
       then []
       else [brk.block])
      + (if std.member(['resource', 'data', 'ephemeral'], brk.block)
         then [brk.resource]
         else [])
      + [brk.key, field]
    ),
}
