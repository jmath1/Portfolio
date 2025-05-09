resource "aws_security_group" "alb_sg" {
  count = var.use_vpc ? 1 : 0

  name        = "alb-sg"
  description = "Allow HTTPS traffic"
  vpc_id      = local.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  count = var.use_vpc ? 1 : 0

  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.use_vpc ? [aws_security_group.alb_sg[0].id] : null
  subnets            = local.public_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  count = var.use_vpc ? 1 : 0

  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = var.use_vpc ? 1 : 0

  target_group_arn = aws_lb_target_group.tg[0].arn
  target_id        = aws_instance.portfolio.id
  port             = 80
}

resource "aws_lb_listener" "https_listener" {
  count = var.use_vpc ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.domain.outputs.acm_main_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}

resource "aws_route53_record" "alb_dns" {
  count = var.use_vpc ? 1 : 0

  zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
  name    = "api.${var.domain_name}.${var.tld}"
  type    = "A"

  alias {
    name                   = aws_lb.alb[0].dns_name
    zone_id                = aws_lb.alb[0].zone_id
    evaluate_target_health = true
  }
}
