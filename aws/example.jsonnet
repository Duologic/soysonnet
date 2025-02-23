local resource = import './generated/resource/route53.libsonnet';

resource.aws_route53_record.new('myrecord', 'thisrecord', 'value1', 5500)
+ resource.aws_route53_record.withTtl('1s')
+ resource.aws_route53_record.alias.withName('aliasname')
