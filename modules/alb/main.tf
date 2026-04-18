resource "aws_lb" "my_lb" {
  name               = "${var.name}-my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [var.lb_sg]
  subnets = var.public_subnets
  #for development only
  enable_deletion_protection = false

  tags = merge(
    { Name = "${var.name}-my-lb" },
    var.tags 
  )
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "forward_ec2_ltg" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate

  default_action {
    type             = "forward"
    target_group_arn = var.ec2_ltg
  }
}