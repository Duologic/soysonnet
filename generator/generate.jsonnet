local a = import 'github.com/crdsonnet/astsonnet/main.libsonnet';
local autils = import 'github.com/crdsonnet/astsonnet/utils.libsonnet';
local helpers = import 'github.com/crdsonnet/crdsonnet/crdsonnet/helpers.libsonnet';
local crdsonnet = import 'github.com/crdsonnet/crdsonnet/crdsonnet/main.libsonnet';
local d = import 'github.com/jsonnet-libs/docsonnet/doc-util/main.libsonnet';

local fields = import './fields.libsonnet';

{
  generateProviderLibrary(schema):
    local ast = crdsonnet.schema.render('provider', schema['$defs'].provider, self.processor(['provider']));

    local docstring =
      a.object.new([
        a.field.new(
          a.string.new('#'),
          a.literal.new(
            std.manifestJsonEx(d.package.newSub('provider', ''), '  ', '\n'),
          ),
        ),
      ]);

    '// DO NOT EDIT: this file is generated by soysonnet\n'
    + autils.deepMergeObjects([docstring, ast]).toString(),

  generateResourceLibrary(schema, group, blockType):
    local asts = [
      crdsonnet.schema.render(field, schema['$defs'][field], self.processor([blockType, field]))
      for field in std.objectFields(schema['$defs'])
    ];

    local docstring =
      a.object.new([
        a.field.new(
          a.string.new('#'),
          a.literal.new(
            std.manifestJsonEx(d.package.newSub(group, ''), '  ', '\n'),
          ),
        ),
      ]);

    '// DO NOT EDIT: this file is generated by soysonnet\n'
    + autils.deepMergeObjects([docstring] + asts).toString(),

  processor(nesting):
    crdsonnet.processor.new('ast')
    + {
      local engine = self.renderEngine.engine,
      render(name, schema):
        local schemaInSpec(schema) = {
          type: 'object',
          properties: { spec: schema },
        };
        local parsedSchema = self.parse(name, schemaInSpec(schema));
        local properties =
          parsedSchema[name].properties.spec.properties
          + { key: { type: 'string' } };
        local required = ['key'] + std.get(parsedSchema[name].properties.spec, 'required', []);
        a.object.new([
          a.field.new(
            a.id.new(name),
            a.object.new(
              fields.constructor(
                engine,
                properties,
                required,
                init=a.object.new([
                  a.object_local.new(
                    a.bind.new(
                      a.id.new('this'),
                      a.literal.new('self')
                    ),
                  ),
                  std.foldr(
                    function(value, acc)
                      a.field.new(
                        a.id.new(value),
                        a.object.new([acc])
                      ),
                    nesting,
                    a.field.new(
                      a.fieldname_expr.new(
                        a.fieldaccess.new([a.id.new('this')], a.id.new('key'))
                      ),
                      a.fieldaccess.new([a.id.new('this')], a.id.new('spec'))
                    ),
                  ),
                  a.field.new(
                    a.id.new('key'),
                    a.id.new('key')
                  )
                  + a.field.withHidden(),
                  a.field.new(
                    a.id.new('spec'),
                    a.object.new([]),
                  )
                  + a.field.withHidden(),
                ])
              )
              + [
                a.field_function.new(
                  a.id.new('withKey'),
                  a.object.new([
                    a.field.new(
                      a.id.new('key'),
                      a.id.new('key')
                    )
                    + a.field.withHidden(),
                  ])
                )
                + a.field_function.withParams(
                  a.params.new([
                    a.param.new(a.id.new('key')),
                  ])
                ),
              ]
              + autils.get(
                autils.get(super.render(name, schemaInSpec(schema)), name).expr,
                'spec'
              ).expr.members
            )
          ),
        ]),
    },
}
