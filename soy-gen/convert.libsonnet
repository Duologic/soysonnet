{
  local convert = self,

  providerSchema(providerName, providerSchema): {
    type: 'block',
    '$defs'+: {
      provider:
        convert.block(providerSchema.block)
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
          [providerName]+: {
            type: 'array',
            items: {
              '$ref': '#/$defs/provider',
            },
          },
        },
      },
    },
  },
  resourceSchema(resourceType, resourceSchema):
    convert.resourceBlock('resource', resourceType, resourceSchema)
    + {
      '$defs'+: {
        [resourceType]+: {
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

  ephemeralResourceSchema(resourceType, resourceSchema):
    convert.resourceBlock('ephemeral', resourceType, resourceSchema),

  dataSourceSchema(resourceType, resourceSchema):
    convert.resourceBlock('data', resourceType, resourceSchema),

  resourceBlock(blockType, resourceType, resourceSchema): {
    type: 'object',
    '$defs'+: {
      [resourceType]:
        convert.block(resourceSchema.block)
        + {
          properties+: {
            provider: { type: 'string' },
            depends_on: { type: 'array', items: { type: 'string' } },
            count: { type: 'number' },
          },
        },
    },
    properties+: {
      [blockType]+: {
        type: 'object',
        properties+: {
          [resourceType]: {
            type: 'object',
            additionalProperties: { '$ref': '#/$defs/%s' % resourceType },
            minProperties: 1,
          },
        },
      },
    },
  },

  block(block): {
    local attributes = std.objectKeysValues(std.get(block, 'attributes', {})),
    local blocks = std.objectKeysValues(std.get(block, 'block_types', {})),

    type: 'object',

    properties:
      {
        [item.key]:
          convert.typeTuple(item.value.type)
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
            convert.block(item.value.block)
          else {
            type: 'array',
            items: convert.block(item.value.block),
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

  typeTuple(input):
    local isTuple = std.isArray(input) && std.length(input) == 2;
    local typeValue =
      if isTuple
      then convert.normalizeType(input[0])
      else if std.isString(input)
      then convert.normalizeType(input)
      else error 'unexpected type: ' + input;

    local hasProperties = isTuple && typeValue == 'object' && std.isObject(input[1]);
    local unique = input == 'set' || input[0] == 'set';
    {
      type: typeValue,

      [if isTuple && typeValue == 'array' then 'items']: convert.typeTuple(input[1]),
      [if unique then 'uniqueItems']: unique,

      [if hasProperties then 'properties']: {
        [item.key]: convert.typeTuple(item.value)
        for item in std.objectKeysValues(input[1])
      },
    }
    + (
      if isTuple && typeValue == 'object' && std.isString(input[1])
      then {
        additionalProperties: { type: convert.normalizeType(input[1]) },
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
    then std.map(convert.normalizeType, input)
    else if std.isString(input)
    then std.get(typeMapping, input, error 'no type mapping for: ' + input)
    else error 'unexpected input: ' + input,
}
