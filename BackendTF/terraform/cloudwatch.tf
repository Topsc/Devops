resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "ECS-Dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ECS", "CPUUtilized", "ClusterName", "${var.ecs_cluster_name}-uat", "ServiceName", "${var.ecs_service_name}-uat" ],
          [ "AWS/ECS", "CPUUtilized", "ClusterName", "${var.ecs_cluster_name}-prod", "ServiceName", "${var.ecs_service_name}-prod" ],
          [ ".", "MemoryUtilized", ".", "${var.ecs_cluster_name}-uat", ".", "${var.ecs_service_name}-uat" ],
          [ ".", "MemoryUtilized", ".", "${var.ecs_cluster_name}-prod", ".", "${var.ecs_service_name}-prod" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-southeast-2",
        "title": "ECS Service - CPU and Memory Utilization"
      }
    }
  ]
}
EOF
}


///create sns
resource "aws_sns_topic" "backend_sns" {

  name = var.sns_name
}

resource "aws_sns_topic_subscription" "user_updates" {

  topic_arn = aws_sns_topic.backend_sns.arn
  protocol  = "email"
  endpoint  = var.sns_email
}


///create alarm and sns
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
  alarm_name          = "ecs_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilized"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric checks cpu utilization"
  alarm_actions       = [aws_sns_topic.backend_sns.arn]
  dimensions = {
    ClusterName = "${var.ecs_cluster_name}-prod"
    ServiceName = "${var.ecs_service_name}-prod"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_alarm_uat" {
  alarm_name          = "ecs_memory_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilized"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric checks memory utilization"
  alarm_actions       = [aws_sns_topic.backend_sns.arn]
  dimensions = {
    ClusterName = "${var.ecs_cluster_name}-uat"
    ServiceName = "${var.ecs_service_name}-uat"
  }
}