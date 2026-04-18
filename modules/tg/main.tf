resource "aws_lb_target_group" "ec2_ltg" {
  name     = var.lb_tg_name
  port     = var.lb_tg_port
  protocol = var.lb_tg_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = var.lb_tg_name
  }
}

resource "aws_lb_target_group_attachment" "ec2_ltg_attachment" {
  for_each = var.ec2_private_instances

  target_group_arn = aws_lb_target_group.ec2_ltg.arn
  target_id        = each.value.id
  port             = 8000
}