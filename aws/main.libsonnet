local soy = import '../main.libsonnet';

local replaceSchemaAtPath(path, schema) =
  local p = std.split(path, '.');
  std.foldr(
    function(key, acc)
      { [key]+: acc },
    p[:std.length(p) - 1],
    { [p[std.length(p) - 1]]: schema }
  );

local getItem(path, schema) =
  local p = std.split(path, '.');
  std.foldl(
    function(acc, key)
      acc[key],
    p,
    schema,
  );

{
  new(
    name='aws',
    source='registry.terraform.io/hashicorp/aws',
    version='5.87.0',
    schema=import '../.build/schema.json'
  ):
    local schemas =
      soy.convert(
        name,
        source,
        version,
        schema,
      )
      + {
        resource+: {
          quicksight+: {
            local newref = { '$refs': '#/$defs/visuals' },
            '$defs'+:
              {
                sheets: super.aws_quicksight_dashboard.properties.definition.properties.sheets,
              }
              + replaceSchemaAtPath('aws_quicksight_dashboard.properties.definition.properties.sheets', newref)
              + replaceSchemaAtPath('aws_quicksight_analysis.properties.definition.properties.sheets', newref)
              + replaceSchemaAtPath('aws_quicksight_template.properties.definition.properties.sheets', newref),
          },
          wafv2+:
            (
              local schema = (import './../schemas/aws/resources/wafv2.json');

              local findStatements(path, schema) =
                local obj = getItem(path, schema);
                std.filterMap(
                  function(item)
                    std.objectHas(item.value.properties, 'statement')
                    || std.objectHas(item.value.properties, 'scope_down_statement'),
                  function(item)
                    local key =
                      if std.objectHas(item.value.properties, 'scope_down_statement')
                      then 'scope_down_statement'
                      else 'statement';
                    std.join('.', [
                      path,
                      item.key,
                      'properties',
                      key,
                    ]),
                  std.objectKeysValues(obj)
                );

              local paths = std.flatMap(
                function(path) findStatements(path, schema),
                [
                  '$defs.aws_wafv2_rule_group.properties.rule.items.properties.statement.properties',
                  '$defs.aws_wafv2_web_acl.properties.rule.items.properties.statement.properties',
                ],
              );

              local s(path) =
                local p = std.split(path, '.');
                local resource = p[2];
                local ref = '#/$defs/%s/properties/rule/items/properties/statement' % resource;

                local obj = getItem(path, schema);
                local type = obj.type;
                {
                  [if type == 'object' then '$refs']: ref,
                  [if type == 'array' then 'type']: type,
                  [if type == 'array' then 'items']: { '$refs': ref },
                };

              std.foldl(
                function(acc, path)
                  acc + replaceSchemaAtPath(path, s(path)),
                paths,
                {}
              )
            ),
        },
      };

    {
      [item.key + '.json']: std.manifestJson(item.value)
      for item in std.objectKeysValues(schemas)
      if item.key == 'provider'
    }
    + {
      [group.key + 's/' + resource.key + '.json']: std.manifestJson(resource.value)
      for group in std.objectKeysValues(schemas)
      if group.key != 'provider'
      for resource in std.objectKeysValues(group.value)
    },
}
