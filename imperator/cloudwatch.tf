resource "aws_sns_topic" "pagerduty_topic" {
  name = "pagerduty-alert"
}

resource "aws_sns_topic_subscription" "pagerduty_subscription" {
  topic_arn = aws_sns_topic.pagerduty_topic.arn
  protocol  = "https"
  endpoint  = var.pagerduty_endpoint
}

resource "aws_cloudwatch_metric_alarm" "fullnode_snapshot_storage_alarm" {
  alarm_name          = "${var.environment}-fullnode-snapshot-storage-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric checks if fullnode_snapshot storage is above 95%"
  alarm_actions       = [aws_sns_topic.pagerduty_topic.arn]
  dimensions = {
    InstanceId = "${var.fullnode_snapshot_instance_id}"
    path = "/"
    fstype = "xfs"
  }
}
