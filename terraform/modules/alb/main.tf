#############################################
# Application Load Balancer
#############################################

resource "aws_lb" "this" {
  name               = "gaurav-task11-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name    = "gaurav-task11-alb"
    Project = "gaurav-task11"
  }
}

#############################################
# Target Group - BLUE
#############################################

resource "aws_lb_target_group" "blue" {
  name        = "gaurav-task11-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
  path                = "/admin"        # Strapi admin path
  matcher             = "200-399"       # Allow redirects
  healthy_threshold   = 2
  unhealthy_threshold = 5
  timeout             = 5
  interval            = 30
}

  tags = {
    Name    = "gaurav-task11-blue"
    Project = "gaurav-task11"
  }
}

#############################################
# Target Group - GREEN
#############################################

resource "aws_lb_target_group" "green" {
  name        = "gaurav-task11-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

 health_check {
  path                = "/admin"        # Strapi admin path
  matcher             = "200-399"       # Allow redirects
  healthy_threshold   = 2
  unhealthy_threshold = 5
  timeout             = 5
  interval            = 30
 }

  tags = {
    Name    = "gaurav-task11-green"
    Project = "gaurav-task11"
  }
}

#############################################
# Listener (Initially points to BLUE)
#############################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}