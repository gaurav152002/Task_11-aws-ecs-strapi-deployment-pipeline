#############################################
# ECS CLUSTER
#############################################

resource "aws_ecs_cluster" "this" {
  name = "gaurav-task11-cluster"

  tags = {
    Name    = "gaurav-task11-cluster"
    Project = "gaurav-task11"
  }
}

#############################################
# ECS TASK DEFINITION
#############################################

resource "aws_ecs_task_definition" "this" {
  family                   = "gaurav-task11-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "512"
  memory = "1024"

  # USE EXISTING ROLE
  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
  task_role_arn      = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.ecr_image_url
      essential = true

      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "NODE_ENV", value = "production" },

        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = var.rds_endpoint },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapi" },
        { name = "DATABASE_USERNAME", value = "strapi" },
        { name = "DATABASE_PASSWORD", value = "Strapi12345" },

        { name = "DATABASE_SSL", value = "true" },
        { name = "DATABASE_SSL_REJECT_UNAUTHORIZED", value = "false" },

        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "APP_KEYS", value = "key1,key2,key3,key4" },
        { name = "JWT_SECRET", value = "supersecretjwt" },
        { name = "ADMIN_JWT_SECRET", value = "adminsecret" },
        { name = "API_TOKEN_SALT", value = "apisalt" }
      ]
    }
  ])

  tags = {
    Name    = "gaurav-task11-task"
    Project = "gaurav-task11"
  }
}

#############################################
# ECS SERVICE (CODE_DEPLOY ENABLED)
#############################################

resource "aws_ecs_service" "this" {
  name            = "gaurav-task11-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # BLUE/GREEN ENABLED
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  # Initially attach BLUE target group
  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  # Required for CodeDeploy
  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name    = "gaurav-task11-service"
    Project = "gaurav-task11"
  }
}