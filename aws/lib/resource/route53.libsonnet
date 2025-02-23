// DO NOT EDIT: this file is generated by soysonnet
{
  '#': {
    help: '',
    name: 'route53',
  },
  aws_route53_record:
    {
      '#new': { 'function': { args: [{ default: null, enums: null, name: 'key', type: 'string' }, { default: null, enums: null, name: 'name', type: 'string' }, { default: null, enums: null, name: 'type', type: 'string' }, { default: null, enums: null, name: 'zone_id', type: 'string' }], help: '' } },
      new(key, name, type, zone_id):
        {
          local this = self,
          resource: {
            aws_route53_record: {
              [this.key]: this.spec,
            },
          },
          key:: key,
          spec:: {

          },
        }
        + self.withKey(key)
        + self.withName(name)
        + self.withType(type)
        + self.withZoneId(zone_id),
      withKey(key): {
        key:: key,
      },
      '#withAlias': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withAlias(value): {
        spec+: {
          alias: value,
        },
      },
      '#withAliasMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withAliasMixin(value): {
        spec+: {
          alias+: value,
        },
      },
      alias+:
        {
          '#withEvaluateTargetHealth': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withEvaluateTargetHealth(value=true): {
            spec+: {
              alias+: {
                evaluate_target_health: value,
              },
            },
          },
          '#withName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withName(value): {
            spec+: {
              alias+: {
                name: value,
              },
            },
          },
          '#withZoneId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withZoneId(value): {
            spec+: {
              alias+: {
                zone_id: value,
              },
            },
          },
        },
      '#withAllowOverwrite': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withAllowOverwrite(value=true): {
        spec+: {
          allow_overwrite: value,
        },
      },
      '#withCidrRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withCidrRoutingPolicy(value): {
        spec+: {
          cidr_routing_policy: value,
        },
      },
      '#withCidrRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withCidrRoutingPolicyMixin(value): {
        spec+: {
          cidr_routing_policy+: value,
        },
      },
      cidr_routing_policy+:
        {
          '#withCollectionId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withCollectionId(value): {
            spec+: {
              cidr_routing_policy+: {
                collection_id: value,
              },
            },
          },
          '#withLocationName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withLocationName(value): {
            spec+: {
              cidr_routing_policy+: {
                location_name: value,
              },
            },
          },
        },
      '#withCount': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withCount(value): {
        spec+: {
          count: value,
        },
      },
      '#withDependsOn': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withDependsOn(value): {
        spec+: {
          depends_on:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withDependsOnMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withDependsOnMixin(value): {
        spec+: {
          depends_on+:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withFailoverRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withFailoverRoutingPolicy(value): {
        spec+: {
          failover_routing_policy: value,
        },
      },
      '#withFailoverRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withFailoverRoutingPolicyMixin(value): {
        spec+: {
          failover_routing_policy+: value,
        },
      },
      failover_routing_policy+:
        {
          '#withType': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withType(value): {
            spec+: {
              failover_routing_policy+: {
                type: value,
              },
            },
          },
        },
      '#withFqdn': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withFqdn(value): {
        spec+: {
          fqdn: value,
        },
      },
      '#withGeolocationRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withGeolocationRoutingPolicy(value): {
        spec+: {
          geolocation_routing_policy: value,
        },
      },
      '#withGeolocationRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withGeolocationRoutingPolicyMixin(value): {
        spec+: {
          geolocation_routing_policy+: value,
        },
      },
      geolocation_routing_policy+:
        {
          '#withContinent': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withContinent(value): {
            spec+: {
              geolocation_routing_policy+: {
                continent: value,
              },
            },
          },
          '#withCountry': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withCountry(value): {
            spec+: {
              geolocation_routing_policy+: {
                country: value,
              },
            },
          },
          '#withSubdivision': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withSubdivision(value): {
            spec+: {
              geolocation_routing_policy+: {
                subdivision: value,
              },
            },
          },
        },
      '#withGeoproximityRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withGeoproximityRoutingPolicy(value): {
        spec+: {
          geoproximity_routing_policy: value,
        },
      },
      '#withGeoproximityRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withGeoproximityRoutingPolicyMixin(value): {
        spec+: {
          geoproximity_routing_policy+: value,
        },
      },
      geoproximity_routing_policy+:
        {
          '#withAwsRegion': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withAwsRegion(value): {
            spec+: {
              geoproximity_routing_policy+: {
                aws_region: value,
              },
            },
          },
          '#withBias': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withBias(value): {
            spec+: {
              geoproximity_routing_policy+: {
                bias: value,
              },
            },
          },
          '#withCoordinates': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withCoordinates(value): {
            spec+: {
              geoproximity_routing_policy+: {
                coordinates:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withCoordinatesMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withCoordinatesMixin(value): {
            spec+: {
              geoproximity_routing_policy+: {
                coordinates+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          coordinates+:
            {
              '#': { help: '', name: 'coordinates' },
              '#withLatitude': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withLatitude(value): {
                latitude: value,
              },
              '#withLongitude': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withLongitude(value): {
                longitude: value,
              },
            },
          '#withLocalZoneGroup': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withLocalZoneGroup(value): {
            spec+: {
              geoproximity_routing_policy+: {
                local_zone_group: value,
              },
            },
          },
        },
      '#withHealthCheckId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withHealthCheckId(value): {
        spec+: {
          health_check_id: value,
        },
      },
      '#withId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withId(value): {
        spec+: {
          id: value,
        },
      },
      '#withLatencyRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLatencyRoutingPolicy(value): {
        spec+: {
          latency_routing_policy: value,
        },
      },
      '#withLatencyRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLatencyRoutingPolicyMixin(value): {
        spec+: {
          latency_routing_policy+: value,
        },
      },
      latency_routing_policy+:
        {
          '#withRegion': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withRegion(value): {
            spec+: {
              latency_routing_policy+: {
                region: value,
              },
            },
          },
        },
      '#withLifecycle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLifecycle(value): {
        spec+: {
          lifecycle: value,
        },
      },
      '#withLifecycleMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLifecycleMixin(value): {
        spec+: {
          lifecycle+: value,
        },
      },
      lifecycle+:
        {
          '#withCreateBeforeDestroy': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withCreateBeforeDestroy(value=true): {
            spec+: {
              lifecycle+: {
                create_before_destroy: value,
              },
            },
          },
          '#withIgnoreChanges': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withIgnoreChanges(value): {
            spec+: {
              lifecycle+: {
                ignore_changes:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withIgnoreChangesMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withIgnoreChangesMixin(value): {
            spec+: {
              lifecycle+: {
                ignore_changes+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withPostcondition': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPostcondition(value): {
            spec+: {
              lifecycle+: {
                postcondition: value,
              },
            },
          },
          '#withPostconditionMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPostconditionMixin(value): {
            spec+: {
              lifecycle+: {
                postcondition+: value,
              },
            },
          },
          postcondition+:
            {
              '#withCondition': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withCondition(value=true): {
                spec+: {
                  lifecycle+: {
                    postcondition+: {
                      condition: value,
                    },
                  },
                },
              },
              '#withErrorMessage': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withErrorMessage(value): {
                spec+: {
                  lifecycle+: {
                    postcondition+: {
                      error_message: value,
                    },
                  },
                },
              },
            },
          '#withPrecondition': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPrecondition(value): {
            spec+: {
              lifecycle+: {
                precondition: value,
              },
            },
          },
          '#withPreconditionMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPreconditionMixin(value): {
            spec+: {
              lifecycle+: {
                precondition+: value,
              },
            },
          },
          precondition+:
            {
              '#withCondition': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withCondition(value=true): {
                spec+: {
                  lifecycle+: {
                    precondition+: {
                      condition: value,
                    },
                  },
                },
              },
              '#withErrorMessage': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withErrorMessage(value): {
                spec+: {
                  lifecycle+: {
                    precondition+: {
                      error_message: value,
                    },
                  },
                },
              },
            },
          '#withPreventDestroy': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withPreventDestroy(value=true): {
            spec+: {
              lifecycle+: {
                prevent_destroy: value,
              },
            },
          },
          '#withReplaceTriggeredBy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withReplaceTriggeredBy(value): {
            spec+: {
              lifecycle+: {
                replace_triggered_by:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withReplaceTriggeredByMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withReplaceTriggeredByMixin(value): {
            spec+: {
              lifecycle+: {
                replace_triggered_by+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
        },
      '#withMultivalueAnswerRoutingPolicy': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withMultivalueAnswerRoutingPolicy(value=true): {
        spec+: {
          multivalue_answer_routing_policy: value,
        },
      },
      '#withName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withName(value): {
        spec+: {
          name: value,
        },
      },
      '#withProvider': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withProvider(value): {
        spec+: {
          provider: value,
        },
      },
      '#withProvisioner': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withProvisioner(value): {
        spec+: {
          provisioner:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withProvisionerMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withProvisionerMixin(value): {
        spec+: {
          provisioner+:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withRecords': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withRecords(value): {
        spec+: {
          records:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withRecordsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withRecordsMixin(value): {
        spec+: {
          records+:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withSetIdentifier': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withSetIdentifier(value): {
        spec+: {
          set_identifier: value,
        },
      },
      '#withTtl': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withTtl(value): {
        spec+: {
          ttl: value,
        },
      },
      '#withType': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withType(value): {
        spec+: {
          type: value,
        },
      },
      '#withWeightedRoutingPolicy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withWeightedRoutingPolicy(value): {
        spec+: {
          weighted_routing_policy: value,
        },
      },
      '#withWeightedRoutingPolicyMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withWeightedRoutingPolicyMixin(value): {
        spec+: {
          weighted_routing_policy+: value,
        },
      },
      weighted_routing_policy+:
        {
          '#withWeight': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withWeight(value): {
            spec+: {
              weighted_routing_policy+: {
                weight: value,
              },
            },
          },
        },
      '#withZoneId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withZoneId(value): {
        spec+: {
          zone_id: value,
        },
      },
    },
}
