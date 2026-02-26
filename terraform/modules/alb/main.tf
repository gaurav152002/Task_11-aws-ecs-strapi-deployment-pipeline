#############################################
# Application Load Balancer
#############################################

resource "aws_lb" "this" {
  name               = "gaurav-task11-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "gaurav-task11-alb"
    Project = "gaurav-task11"
  }
}

#############################################
# BLUE Target Group
#############################################

resource "aws_lb_target_group" "blue" {
  name        = "gaurav-task11-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check { path = "/" }

  tags = {
    Name = "gaurav-task11-blue"
    Project = "gaurav-task11"
  }
}

#############################################
# GREEN Target Group
#############################################

resource "aws_lb_target_group" "green" {
  name        = "gaurav-task11-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check { path = "/" }

  tags = {
    Name = "gaurav-task11-green"
    Project = "gaurav-task11"
  }
}

#############################################
# Listener (initially forwards to BLUE)
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