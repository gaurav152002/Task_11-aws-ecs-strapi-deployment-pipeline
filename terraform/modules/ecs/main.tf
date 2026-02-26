#############################################
# ECS Cluster
#############################################

resource "aws_ecs_cluster" "this" {
  name = "gaurav-task11-cluster"

  tags = {
    Name = "gaurav-task11-cluster"
    Project = "gaurav-task11"
  }
}

#############################################
# ECS Task Definition
#############################################

resource "aws_ecs_task_definition" "this" {
  family                   = "gaurav-task11-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "512"
  memory = "1024"

  # Hardcoded IAM roles (org restriction)
  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
  task_role_arn      = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.ecr_image_url   # Initially latest, updated via GitHub

      essential = true

      portMappings = [{
        containerPort = 1337
        hostPort      = 1337
      }]

      environment = [
        { name = "DATABASE_HOST", value = var.rds_endpoint },
        { name = "DATABASE_NAME", value = "strapi" },
        { name = "DATABASE_USERNAME", value = "strapi" },
        { name = "DATABASE_PASSWORD", value = "Strapi12345" }
      ]
    }
  ])

  tags = {
    Name = "gaurav-task11-task"
    Project = "gaurav-task11"
  }
}

#############################################
# ECS Service (CodeDeploy Enabled)
#############################################

resource "aws_ecs_service" "this" {
  name            = "gaurav-task11-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Enable Blue/Green via CodeDeploy
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  # Prevent terraform from overriding new revisions
  lifecycle {
    ignore_changes = [task_definition]
  }
}