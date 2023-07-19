# ECS
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = var.name
  tags = {
    Name        = "${var.name}-cluster"
  }
}
