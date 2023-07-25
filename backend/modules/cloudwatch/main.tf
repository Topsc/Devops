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
          [ "ECS/ContainerInsights", "CpuUtilized", "ClusterName", "${var.app_name}-ecs-cluster-${var.app_environment_uat}", "ServiceName", "${var.app_name}-ecs-service-${var.app_environment_uat}" ],
          [ "ECS/ContainerInsights", "CpuUtilized", "ClusterName", "${var.app_name}-ecs-cluster-${var.app_environment_prod}", "ServiceName", "${var.app_name}-ecs-service-${var.app_environment_prod}" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-southeast-2",
        "title": "ECS Service - CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 13,
      "y": 0, 
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "ECS/ContainerInsights", "MemoryUtilized", "ClusterName", "${var.app_name}-ecs-cluster-${var.app_environment_uat}", "ServiceName", "${var.app_name}-ecs-service-${var.app_environment_uat}" ],
          [ "ECS/ContainerInsights", "MemoryUtilized", "ClusterName", "${var.app_name}-ecs-cluster-${var.app_environment_prod}", "ServiceName", "${var.app_name}-ecs-service-${var.app_environment_prod}" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-southeast-2",
        "title": "ECS Service - Memory Utilization"
      }
    }
  ]
}
EOF
}
resource "aws_cloudwatch_dashboard" "alb_dashboard" {
  dashboard_name = "ALB-Dashboard"

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
          [ "AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", "${var.app_name}-alb" ],
          [ ".", "HTTPCode_Target_5XX_Count", ".", "." ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-southeast-2",
        "title": "ALB - HTTP 4xx and 5xx Errors"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${var.app_name}-alb" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-southeast-2",
        "title": "ALB - Response Time"
      }
    }
  ]
}
EOF
}

///create sns
resource "aws_sns_topic" "backend_sns" {
  name = "${var.app_name}-backend-sns"
}

resource "aws_sns_topic_subscription" "user_updates" {
  topic_arn = aws_sns_topic.backend_sns.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

///create alarm and sns
# resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm_prod" {
#   alarm_name          = "ecs_cpu_alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilized"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This metric checks cpu utilization"
#   alarm_actions       = [aws_sns_topic.backend_sns.arn]
#   dimensions = {
#     ClusterName = "${var.app_name}-ecs-cluster-${var.app_environment_prod}"
#     ServiceName = "${var.app_name}-ecs-service-${var.app_environment_prod}"
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "ecs_memory_alarm_uat" {
#   alarm_name          = "ecs_memory_alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "MemoryUtilized"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This metric checks memory utilization"
#   alarm_actions       = [aws_sns_topic.backend_sns.arn]
#   dimensions = {
#     ClusterName = "${var.app_name}-ecs-cluster-${var.app_environment_uat}"
#     ServiceName = "${var.app_name}-ecs-service-${var.app_environment_uat}"
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm_uat" {
#   alarm_name          = "ecs_cpu_alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilized"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This metric checks cpu utilization"
#   alarm_actions       = [aws_sns_topic.backend_sns.arn]
#   dimensions = {
#     ClusterName = "${var.app_name}-ecs-cluster-${var.app_environment_uat}"
#     ServiceName = "${var.app_name}-ecs-service-${var.app_environment_uat}"
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "ecs_memory_alarm_prod" {
#   alarm_name          = "ecs_memory_alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "MemoryUtilized"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This metric checks memory utilization"
#   alarm_actions       = [aws_sns_topic.backend_sns.arn]
#   dimensions = {
#     ClusterName = "${var.app_name}-ecs-cluster-${var.app_environment_prod}"
#     ServiceName = "${var.app_name}-ecs-service-${var.app_environment_prod}"
#   }
# }

///alb alarm 
resource "aws_cloudwatch_metric_alarm" "alb_4xx_alarm" {
  alarm_name          = "alb_4xx_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "This metric checks for 4xx errors"
  alarm_actions       = [aws_sns_topic.backend_sns.arn]
  dimensions = {
    LoadBalancer = "${var.app_name}-alb"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_alarm" {
  alarm_name          = "alb_5xx_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "This metric checks for 5xx errors"
  alarm_actions       = [aws_sns_topic.backend_sns.arn]
  dimensions = {
    LoadBalancer = "${var.app_name}-alb"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_response_time_alarm" {
  alarm_name          = "alb_response_time_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0.5"
  alarm_description   = "This metric checks response time"
  alarm_actions       = [aws_sns_topic.backend_sns.arn]
  dimensions = {
    LoadBalancer = "${var.app_name}-alb"
  }
}
