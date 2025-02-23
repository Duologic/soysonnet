local a = import 'github.com/crdsonnet/astsonnet/main.libsonnet';
local autils = import 'github.com/crdsonnet/astsonnet/utils.libsonnet';
local helpers = import 'github.com/crdsonnet/crdsonnet/crdsonnet/helpers.libsonnet';
local crdsonnet = import 'github.com/crdsonnet/crdsonnet/crdsonnet/main.libsonnet';
local d = import 'github.com/jsonnet-libs/docsonnet/doc-util/main.libsonnet';

{
  local defaultInit = a.object.new([]),
  constructor(engine, properties, required, init=defaultInit): [
    // `#new` Docstring
    a.field.new(
      a.string.new('#new'),
      a.literal.new(
        std.manifestJsonEx(
          d.func.new('', [
            local p = properties[property];
            local propertyType = p.type;
            //if 'type' in p
            //then p.type
            //else
            //  local t = helpers.getSchemaTypes(p);
            //  if t == ['string'] then ['object'] else t;
            d.argument.new(
              property,
              (propertyType),
              std.get(p, 'default'),
              std.get(p, 'enum'),
            )
            for property in required
          ])
          , '', ''
        ),
      ),
    ),

    // `new()` Function
    a.field_function.new(
      a.id.new('new'),
      (if std.length(required) > 0
       then
         a.binary_sum.new(
           (if init == defaultInit
            then []
            else [init])
           + [
             a.functioncall.new(
               a.fieldaccess.new(
                 [a.id.new('self')],
                 a.id.new(engine.functionName(property)),
               )
             )
             + a.functioncall.withArgs(
               a.arg.new(a.id.new(property))
             )
             for property in required
           ]
         )
       else defaultInit)
    )
    + a.field_function.withParams(
      a.params.new([
        a.param.new(a.id.new(property))
        for property in required
      ])
    ),
  ],
}
