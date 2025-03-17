# soy-common

Utility functions to work with generated soysonnet libraries.

## Index

* [func manifestResources](func-manifestresources)
* [func getBlockResourceKey](func-getblockresourcekey)
* [func requiredProvider](func-requiredprovider)
  * [obj requiredProvider().terraform](obj-requiredproviderterraform)
    * [obj requiredProvider().terraform.required_providers](obj-requiredproviderterraformrequiredproviders)
* [func importResource](func-importresource)
* [func withDynamicBlock](func-withdynamicblock)
  * [obj withDynamicBlock().dynamic](obj-withdynamicblockdynamic)
* [func ref](func-ref)

## Fields

### func manifestResources

```jsonnet
manifestResources(items)
```

This function will manifest all blocks/resources and merge them together into Hashicorp's JSON Configuration Syntax.

Example:

```jsonnet
local aws = import 'github.com/Duologic/soysonnet-aws/soy-aws/main.libsonnet';
local soy = import 'github.com/Duologic/soysonnet/soy-common/main.libsonnet';

local resources = {
    provider: aws.provider.provider.new('aws'),
    record: aws.resource.route53.aws_route53_record.new('myrecord', 'thisrecord', 'value1', 5500)
  };

soy.manifestResources(resources)
```

### func getBlockResourceKey

```jsonnet
getBlockResourceKey(resource)
```

Get the block, potential resource and key values for a block.

### func requiredProvider

```jsonnet
requiredProvider(name, source, version)
```

Configure required_providers block

#### obj requiredProvider().terraform

##### obj requiredProvider().terraform.required_providers

### func importResource

```jsonnet
importResource(resource, id)
```

Configure Import resource block

### func withDynamicBlock

```jsonnet
withDynamicBlock(key, foreach, content)
```

Configure a Dynamic block

#### obj withDynamicBlock().dynamic

### func ref

```jsonnet
ref(resource, field)
```

Generate a reference to a value.

