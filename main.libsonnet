{
  local root = self,

  convert(name, source, version, schema):
    local providerSchema = schema.provider_schemas[source];
    {
      provider:
        root.convertProvider(name, providerSchema.provider),

      resource: std.foldl(
        function(acc, item)
          assert std.trace(item.key, true);
          acc + { [std.split(item.key, '_')[1]]+: root.convertResource(item.key, item.value) },
        std.objectKeysValues(std.get(providerSchema, 'resource_schemas', {})),
        {}
      ),

      ephemeral: std.foldl(
        function(acc, item)
          assert std.trace(item.key, true);
          acc + { [std.split(item.key, '_')[1]]+: root.convertEphemeral(item.key, item.value) },
        std.objectKeysValues(std.get(providerSchema, 'ephemeral_resource_schemas', {})),
        {}
      ),

      data_source: std.foldl(
        function(acc, item)
          assert std.trace(item.key, true);
          acc + { [std.split(item.key, '_')[1]]+: root.convertDatasource(item.key, item.value) },
        std.objectKeysValues(std.get(providerSchema, 'data_source_schemas', {})),
        {}
      ),
    },

  fileOutput(name, source, version, schema):
    local schemas = root.convert(name, source, version, schema);
    {
      [item.key + '.json']: std.manifestJson(item.value)
      for item in std.objectKeysValues(schemas)
      if item.key == 'provider'
    }
    + {
      ['resources/' + resource.key + '.json']: std.manifestJson(resource.value)
      for group in std.objectKeysValues(schemas)
      if group.key != 'provider'
      for resource in std.objectKeysValues(group.value)
    },

  convertProvider(name, resource): {
    '$defs'+: {
      provider:
        root.convertBlock(resource.block)
        + {
          properties+: {
            alias: { type: 'string' },
          },
        },
    },
    properties+: {
      provider: {
        type: 'object',
        properties: {
          [name]+: {
            type: 'array',
            items: {
              '$refs': '#/$defs/provider',
            },
          },
        },
      },
    },
  },

  convertResource(name, resource):
    root.convertResourceBlock('resource', name, resource)
    + {
      '$defs'+: {
        [name]+: {
          properties+: {
            provisioner: {
              type: 'array',
              items: { type: 'object' },
            },
            lifecycle: {
              type: 'object',
              properties: {
                create_before_destroy: { type: 'boolean' },
                prevent_destroy: { type: 'boolean' },
                ignore_changes: {
                  type: 'array',
                  items: { type: 'string' },
                },
                replace_triggered_by: {
                  type: 'array',
                  items: { type: 'string' },
                },
                precondition: {
                  type: 'object',
                  properties: {
                    condition: { type: 'boolean' },
                    error_message: { type: 'string' },
                  },
                },
                postcondition: {
                  type: 'object',
                  properties: {
                    condition: { type: 'boolean' },
                    error_message: { type: 'string' },
                  },
                },
              },
            },
          },
        },
      },
    },

  convertEphemeral(name, resource):
    root.convertResourceBlock('ephemeral', name, resource),

  convertDatasource(name, resource):
    root.convertResourceBlock('data', name, resource),

  convertResourceBlock(type, name, resource): {
    '$defs'+: {
      [name]:
        root.convertBlock(resource.block)
        + {
          properties+: {
            provider: { type: 'string' },
            depends_on: { type: 'array', items: { type: 'string' } },
            count: { type: 'number' },
          },
        },
    },
    properties+: {
      [type]+: {
        type: 'object',
        properties+: {
          [name]: {
            type: 'object',
            additionalProperties: { '$refs': '#/$defs/%s' % name },
            minProperties: 1,
          },
        },
      },
    },
  },

  convertBlock(block): {
    local attributes = std.objectKeysValues(std.get(block, 'attributes', {})),
    local blocks = std.objectKeysValues(std.get(block, 'block_types', {})),

    type: 'object',

    properties:
      {
        [item.key]:
          root.convertTypeTuple(item.value.type)
          + {
            [if 'description' in item.value then 'description']:
              std.toString(item.value.description),
          }
        for item in attributes
      }
      + {
        [item.key]:
          if
            std.member(['map', 'single'], std.get(item.value, 'nesting_mode'))
            || (
              std.member(['set', 'list'], std.get(item.value, 'nesting_mode', ''))
              && std.get(item.value, 'max_items') == 1
            )
          then
            root.convertBlock(item.value.block)
          else {
            type: 'array',
            items: root.convertBlock(item.value.block),
          }
        for item in blocks
      },

    required:
      std.set(
        std.filterMap(
          function(item)
            std.get(item.value, 'required', false),
          function(item)
            item.key,
          attributes,
        )
        + std.filterMap(
          function(item)
            std.get(item.value, 'min_items', 0) > 0,
          function(item)
            item.key,
          blocks
        ),
      ),
  },

  convertTypeTuple(input):
    local isTuple = std.isArray(input) && std.length(input) == 2;
    local typeValue =
      if isTuple
      then root.normalizeType(input[0])
      else if std.isString(input)
      then root.normalizeType(input)
      else error 'unexpected type: ' + input;

    local hasProperties = isTuple && typeValue == 'object' && std.isObject(input[1]);
    local unique = input == 'set' || input[0] == 'set';
    {
      type: typeValue,

      [if isTuple && typeValue == 'array' then 'items']: root.convertTypeTuple(input[1]),
      [if unique then 'uniqueItems']: unique,

      [if hasProperties then 'properties']: {
        [item.key]: root.convertTypeTuple(item.value)
        for item in std.objectKeysValues(input[1])
      },
    }
    + (
      if isTuple && typeValue == 'object' && std.isString(input[1])
      then {
        additionalProperties: { type: root.normalizeType(input[1]) },
      }
      else {}
    ),

  normalizeType(input):
    local typeMapping = {
      string: 'string',
      number: 'number',
      bool: 'boolean',
      list: 'array',
      set: 'array',
      map: 'object',
      object: 'object',
    };
    if std.isArray(input)
    then std.map(root.normalizeType, input)
    else if std.isString(input)
    then std.get(typeMapping, input, error 'no type mapping for: ' + input)
    else error 'unexpected input: ' + input,
}
