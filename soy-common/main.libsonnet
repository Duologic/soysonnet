local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

// Utility functions to work with generated soysonnet libraries.
{
  // This function will manifest all blocks/resources and merge them together into Hashicorp's JSON Configuration Syntax.
  //
  // Example:
  //
  // ```jsonnet
  // local aws = import 'github.com/Duologic/soysonnet-aws/soy-aws/main.libsonnet';
  // local soy = import 'github.com/Duologic/soysonnet/soy-common/main.libsonnet';
  //
  // local resources = {
  //     provider: aws.provider.provider.new('aws'),
  //     record: aws.resource.route53.aws_route53_record.new('myrecord', 'thisrecord', 'value1', 5500)
  //   };
  //
  // soy.manifestResources(resources)
  // ```
  manifestResources(items):
    local resources =
      xtd.inspect.filterObjects(
        function(obj)
          std.isFunction(
            std.get(obj, '_manifest')
          ),
        items
      );
    std.foldl(
      function(acc, resource)
        local brk = self.getBlockResourceKey(resource);
        assert brk == '' || !std.member(acc.brks, brk)
               : 'Duplicate resource: \n' + std.manifestJson(brk);
        acc + {
          brks+: (
            if brk.key != ''
            then [brk]
            else []
          ),
          resources+: resource._manifest(),
        },
      resources,
      { resources: {}, brks: [] },
    ).resources,

  // Get the block, potential resource and key values for a block.
  getBlockResourceKey(resource):
    local m = resource._manifest();
    local block = std.objectFields(m)[0];
    {
      block: block,
      [if std.member(['resource', 'data', 'ephemeral'], block) then 'resource']: std.objectFields(m[block])[0],
      key:
        if std.member(['resource', 'data', 'ephemeral'], block)
        then std.objectFields(m[block][self.resource])[0]
        else if std.isObject(m[block])
        then std.objectFields(m[block])[0]
        else '',
    },

  // Configure required_providers block
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

  // Configure Import resource block
  importResource(resource, id):
    local brk = self.getBlockResourceKey(resource);
    {
      _manifest():: self,
      'import'+: [{
        to: std.join('.', [brk.resource, brk.key]),
        id: id,
      }],
    },

  // Configure a Dynamic block
  withDynamicBlock(key, foreach, content): {
    dynamic+: {
      [key]: {
        for_each: foreach,
        content: content,
      },
    },
  },

  // Generate a reference to a value.
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
