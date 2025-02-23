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
    schema=import '.build/schema.json'
  ):
    local aws = soy.new(
      name,
      source,
      version,
      schema,
    );
    local schemas =
      {
        provider:
          aws.provider.getSchema(),
        resource:
          aws.resource.getSchemas(
            function(key)
              std.startsWith(key, 'aws_route53_record')
          ),
        ephemeral:
          aws.ephemeral.getSchemas(
            function(key)
              std.startsWith(key, 'aws_kms_')
          ),
        data:
          aws.data.getSchemas(
            function(key)
              std.startsWith(key, 'aws_acm_')
          ),
      }
      + {
        // some schemas have big and/or recursive patterns, this leads to very big schemas, below functions modify the schemas to make them slightly more manageable while functionally still the same
        resource+: {
          [if 'quicksight' in super then 'quicksight']+: (
            local newref = { '$ref': '#/$defs/visuals' };
            {
              '$defs'+: {
                sheets: super.aws_quicksight_dashboard.properties.definition.properties.sheets,
              },
            }
            + replaceSchemaAtPath('$defs.aws_quicksight_dashboard.properties.definition.properties.sheets', newref)
            + replaceSchemaAtPath('$defs.aws_quicksight_analysis.properties.definition.properties.sheets', newref)
            + replaceSchemaAtPath('$defs.aws_quicksight_template.properties.definition.properties.sheets', newref)
          ),
          [if 'wafv2' in super then 'wafv2']+: (
            local schema = super.wafv2;

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
                [if type == 'object' then '$ref']: ref,
                [if type == 'array' then 'type']: type,
                [if type == 'array' then 'items']: { '$ref': ref },
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

    aws.provider.generateLibrary(schemas.provider)
    + aws.resource.generateLibraries(schemas.resource)
    + aws.ephemeral.generateLibraries(schemas.ephemeral)
    + aws.data.generateLibraries(schemas.data),
}
