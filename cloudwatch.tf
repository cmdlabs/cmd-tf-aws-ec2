resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm_systemcheck" {
  count = var.enable_ec2_autorecovery ? 1 : 0

  alarm_name          = "EC2AutoRecover-SystemCheckRecoveryAlarm-${var.instance_name}"
  threshold           = "0"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  evaluation_periods  = 2
  statistic           = "Maximum"
  alarm_actions       = compact(["arn:aws:automate:${data.aws_region.current.name}:ec2:recover", var.cloudwatch_sns_topic_arn])
  alarm_description   = "Trigger a recovery when system status check fails for 2 minutes"

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm_instancecheck" {
  count = var.enable_ec2_autorecovery ? 1 : 0

  alarm_name          = "EC2AutoRecover-InstanceCheckRecoveryAlarm-${var.instance_name}"
  threshold           = "0"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 60
  evaluation_periods  = 2
  statistic           = "Maximum"
  alarm_actions       = compact(["arn:aws:automate:${data.aws_region.current.name}:ec2:reboot", var.cloudwatch_sns_topic_arn])
  alarm_description   = "Trigger a recovery when instance status check fails for 2 minutes"

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  tags = var.tags
}
