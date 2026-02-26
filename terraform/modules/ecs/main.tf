#############################################
# ECS Cluster
#############################################

resource "aws_ecs_cluster" "this" {
  name = "gaurav-task11-cluster"

  tags = {
    Name    = "gaurav-task11-cluster"
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

  ###################################################
  # Hardcoded IAM roles (org restriction)
  ###################################################

  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
  task_role_arn      = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  ###################################################
  # Container Definition
  ###################################################

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.ecr_image_url  # Initially :latest, updated via GitHub Actions

      essential = true

      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]

      ###################################################
      # Environment Variables (CRITICAL FIX)
      ###################################################

      environment = [
        # Production Mode
        { name = "NODE_ENV", value = "production" },

        # REQUIRED → prevents sqlite fallback crash
        { name = "DATABASE_CLIENT", value = "postgres" },

        # RDS Configuration
        { name = "DATABASE_HOST", value = var.rds_endpoint },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapi" },
        { name = "DATABASE_USERNAME", value = "strapi" },
        { name = "DATABASE_PASSWORD", value = "Strapi12345" },
        { name = "DATABASE_SSL", value = "false" },

        # Strapi Production Secrets
        { name = "APP_KEYS", value = "key1,key2,key3,key4" },
        { name = "JWT_SECRET", value = "supersecretjwt" },
        { name = "API_TOKEN_SALT", value = "apisalt" },
        { name = "ADMIN_JWT_SECRET", value = "adminsecret" },

        # Server Binding
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" }
      ]
    }
  ])

  tags = {
    Name    = "gaurav-task11-task"
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

  ###################################################
  # Enable Blue/Green via CodeDeploy
  ###################################################

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  ###################################################
  # Networking
  ###################################################

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  ###################################################
  # Attach Blue Target Group Initially
  ###################################################

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  ###################################################
  # Prevent Terraform From Overwriting New Revisions
  ###################################################

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name    = "gaurav-task11-service"
    Project = "gaurav-task11"
  }
}