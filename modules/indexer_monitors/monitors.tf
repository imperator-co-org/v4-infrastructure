resource "datadog_monitor_json" "socks_kafka_offset" {
  count = var.enable_precautionary_monitors ? 1 : 0

  monitor = <<EOF
{
	"id": 117804982,
	"name": "[${var.environment}] Indexer Socks has high kafka offset",
	"type": "query alert",
	"query": "min(last_10m):top(avg:aws.kafka.max_offset_lag{cluster_name:${var.msk_cluster_name},consumer_group:socks_*} by {consumer_group}.fill(last), 5, 'mean', 'asc') > 1000",
	"message": "Max Kafka Offset is > 1000 for at least 1 socks instance. This means delayed notifications for all websocket messages.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 1000
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"renotify_interval": 0,
		"notify_by": [
			"*"
		],
		"include_tags": false,
		"evaluation_delay": 900,
		"new_group_delay": 60,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "orderbook_crossed" {
  count = var.enable_precautionary_monitors ? 1 : 0

  monitor = <<EOF
{
	"id": 120397508,
	"name": "[${var.environment}] Indexer Orderbook crossed for {{clob_pair_id.name}}",
	"type": "query alert",
	"query": "max(last_10m):default_zero(avg:roundtable.crossed_orderbook.best_ask_human{env:${var.environment},!clob_pair_id:33} by {clob_pair_id} - avg:roundtable.crossed_orderbook.best_bid_human{env:${var.environment},!clob_pair_id:33} by {clob_pair_id}) < 0",
    "message": "Orderbook has been crossed for more than 10 minutes for {{clob_pair_id.name}} . This may be an instance of a stale orderbook level that was not removed.\n\nImpact:\nThe stale orderbook level will affect the FE and API, leading users to have inaccurate assumptions of what price orders will fill at.\n\nResolution:\nClear the stale orderbook levels from redis.\n\n{{#is_recovery}}\n${var.pagerduty_tag}\n{{/is_recovery}}\n${var.alert_webhook}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
        "escalation_message": "Orderbook has been crossed for more than 10 minutes for {{clob_pair_id.name}} . This may be an instance of a stale orderbook level that was not removed.\n\nImpact:\nThe stale orderbook level will affect the FE and API, leading users to have inaccurate assumptions of what price orders will fill at.\n\nResolution:\nClear the stale orderbook levels from redis.\n\n{{#is_alert}}\n${var.pagerduty_tag}\n{{/is_alert}}\n\n{{#is_renotify}}\n${var.pagerduty_tag}\n{{/is_renotify}}\n\n{{#is_recovery}}\n${var.pagerduty_tag}\n{{/is_recovery}}\n\n${var.slack_channel}\n${var.alert_webhook}",
		"thresholds": {
			"critical": 0
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"renotify_interval": 10,
        "renotify_statuses": [
            "alert",
            "no data"
        ],
		"include_tags": true,
		"new_group_delay": 60,
		"silenced": {
			"*": 1694628453
		}
	},
	"priority": 3,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "indexer_not_processing_blocks" {
  count = var.enable_precautionary_monitors ? 1 : 0

  monitor = <<EOF
{
	"id": 2666272,
	"name": "[mainnet] Indexer is not processing blocks",
	"type": "query alert",
	"query": "sum(last_1m):avg:ender.processed_block.timing.count{*}.as_rate() < 0.5",
	"message": "Indexer has not been processing blocks for the last minute. Please check if it's an Ender issue or if the Indexer full node is down.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 0.5
		},
		"notify_audit": false,
		"include_tags": false,
		"notify_no_data": true,
		"no_data_timeframe": 2,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "indexer_full_node_down" {
  count = var.enable_precautionary_monitors ? 1 : 0

  monitor = <<EOF
{
	"id": 2699701,
	"name": "[mainnet] Indexer full node validator cluster has less than 1 task in past 1 minute",
	"type": "query alert",
	"query": "avg(last_1m):avg:aws.ecs.service.running{cluster:mainnet-indexer-full-node-cluster} < 1",
	"message": "Indexer full node validator cluster has less than 1 task in past 1 minute\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 1
		},
		"notify_audit": false,
		"include_tags": false,
		"evaluation_delay": 900,
		"notify_no_data": false,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "indexer_backup_full_node_down" {
  count = var.enable_precautionary_monitors ? 1 : 0

  monitor = <<EOF
{
	"id": 142147978,
	"name": "[mainnet] Indexer backup full node validator cluster has less than 1 task in past 5 minutes",
	"type": "query alert",
	"query": "avg(last_5m):avg:aws.ecs.service.running{cluster:mainnet-indexer-full-node-backup-cluster} < 1",
	"message": "Indexer backup full node validator cluster has less than 1 task in past 5 minutes\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 1
		},
		"notify_audit": false,
		"include_tags": false,
		"evaluation_delay": 900,
		"notify_no_data": false,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "last_processed_block_last_30min" {
  monitor = <<EOF
{
	"id": 107439681,
	"name": "[${var.environment}] Indexer Last processed block on Indexer is > 10 blocks behind latest block",
	"type": "query alert",
	"query": "min(last_30m):max:dydxprotocol.cometbft_consensus_height{env:${var.environment}} - max:ender.processing_block_height{env:${var.environment},service:indexer} > 10",
  "message": "${local.critical_monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 10
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": true,
		"renotify_interval": 0,
		"include_tags": false,
		"no_data_timeframe": 60,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "last_processed_block_last_10min" {
  monitor = <<EOF
{
	"id": 132789180,
	"name": "[${var.environment}] Indexer Last processed block on Indexer is > 100 blocks behind latest block",
	"type": "query alert",
	"query": "min(last_10m):max:dydxprotocol.cometbft_consensus_height{env:${var.environment}} - max:ender.processing_block_height{env:${var.environment},service:indexer} > 100",
  "message": "${local.critical_monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 100
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": true,
		"renotify_interval": 0,
		"include_tags": false,
		"no_data_timeframe": 60,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "on_chain_kafka_offset" {
  monitor = <<EOF
{
	"id": 132789224,
	"name": "[${var.environment}] Indexer High Kafka offset lag for on-chain messages",
	"type": "query alert",
	"query": "min(last_10m):avg:aws.kafka.max_offset_lag{topic:to-ender AND cluster_name IN (${var.msk_cluster_name}) AND consumer_group:ender} by {cluster_name} > 10",
	"message": "Max. offset lag for the `to-ender` Kafka topic is > 10 meaning on-chain updates are delayed.\n\nResolution:\n- investigate why `ender` task running in ECS is not consuming from Kafka topic\n\n${local.critical_monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 10
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"renotify_interval": 0,
		"include_tags": false,
		"evaluation_delay": 900,
		"new_group_delay": 0,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "off_chain_kafka_offset" {
  monitor = <<EOF
{
	"id": 116939320,
	"name": "[${var.environment}] Indexer High Kafka offset lag for off-chain messages",
	"type": "query alert",
	"query": "min(last_1h):avg:aws.kafka.max_offset_lag{topic:to-vulcan AND cluster_name IN (${var.msk_cluster_name}) AND consumer_group:vulcan} by {cluster_name} > 100",
	"message": "Max. offset lag for the `to-vulcan` Kafka topic is > 100 meaning order OPEN / CANCEL and order book updates are delayed.\n\nFollow the steps in this [runbook entry](https://www.notion.so/dydx/Publicly-Shared-Indexer-Oncall-Runbook-3d7ca52b11254bb2a3677bcd69a65d46?pvs=4#ad4748d9abb3460384ba3f25817b7208).\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 100
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"renotify_interval": 0,
		"include_tags": false,
		"evaluation_delay": 900,
		"new_group_delay": 0,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "fast_sync_snapshots" {
  monitor = <<EOF
{
    "id": 131752782,
    "name": "[${var.environment}] Indexer fast sync snapshots haven't been uploaded in the last day",
    "type": "query alert",
    "query": "sum(last_1d):sum:aws.s3.put_requests{bucketname:${local.snapshot_bucket_prefix}-full-node-snapshots}.as_count() < 1",
    "message": "Indexer fast sync snapshots haven't been uploaded in the last day. Please investigate the snapshotting full node.\n\n${local.monitor_suffix_literal}${local.monitor_no_data_suffix_literal}",
    "tags": [
        "team:${var.team}",
        "env:${var.env_tag}"
    ],
    "options": {
        "thresholds": {
            "critical": 1
        },
        "notify_audit": false,
        "require_full_window": false,
        "notify_no_data": true,
        "renotify_interval": 720,
        "renotify_no_data": true,
        "include_tags": false,
        "evaluation_delay": 900,
        "no_data_timeframe": 1440,
        "new_host_delay": 300,
        "silenced": {}
    },
    "priority": null,
    "restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "socks_client_forwarding_success_rate" {
  monitor = <<EOF
{
	"id": 116939320,
	"name": "[${var.environment}] Websocket messages are not being forwarded to clients",
	"type": "query alert",
	"query": "sum(last_5m):avg:socks.forward_to_client_success{*}.as_count() / (avg:socks.forward_to_client_success{*}.as_count() + avg:socks.forward_to_client_error{*}.as_count()) < 0.95",
	"message": "Websocket messages are not being forwarded to clients. Please investigate socks logs.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
      "thresholds": {
          "critical": 0.95
      },
      "notify_audit": false,
      "include_tags": false,
      "notify_no_data": false,
      "new_host_delay": 300,
      "silenced": {}
  },
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "elevated_internal_server_errors" {
  monitor = <<EOF
{
	"id": 2704587,
	"name": "[${var.environment}] Comlink Elevated Internal Server Errors",
	"type": "query alert",
	"query": "sum(last_5m):avg:comlink.response_status_code.500{*}.as_count() / avg:comlink.response_status_code.200{*}.as_count() > 0.1",
  "message": "Elevated Internal Server Errors from Comlink. Check Comlink logs/RDS for any issues.\n\n${local.monitor_suffix_literal}",
  "tags": [
      "team:${var.team}",
      "env:${var.env_tag}"
  ],
  "options": {
      "thresholds": {
          "critical": 0.1
      },
      "notify_audit": false,
      "include_tags": false,
      "notify_no_data": false,
      "silenced": {}
  },
  "priority": null,
  "restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "ec2_status_check_failed" {
  monitor = <<EOF
{
	"id": 2704589,
	"name": "[${var.environment}] EC2 Status failed",
	"type": "query alert",
  "query": "avg(last_5m):aws.ec2.status_check_failed{env:*${var.environment}} by {name} > 0",
  "message": "EC2 validator name {{name.name}}. Please check the instance to investigate further.\n\n${local.monitor_suffix_literal}",
  "tags": [
      "team:${var.team}",
      "env:${var.env_tag}"
  ],
  "options": {
      "thresholds": {
          "critical": 0
      },
      "notify_audit": false,
      "include_tags": false,
      "notify_no_data": false,
      "silenced": {}
  },
  "priority": null,
  "restricted_roles": null
}
EOF
}
