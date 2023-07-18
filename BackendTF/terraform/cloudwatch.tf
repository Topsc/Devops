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