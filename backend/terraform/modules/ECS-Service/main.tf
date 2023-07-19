resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster              = var.ecs-cluster-id
  task_definition      = "${var.task-def-family}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = var.subnet-ids
    assign_public_ip = true
    security_groups = [
      var.sg_id
    ]
  }

}
