# # create an ec2 instance that will have docker containers for prometheus and grafana that will have the metrics for the web application and rds

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"]
# }
# resource "aws_instance" "metrics" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.deployer.key_name
#   subnet_id     = local.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.metrics_sg.id]
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

#   user_data = <<-EOF

#     #!/bin/bash
#     sudo apt-get update -y
#     sudo apt-get install docker.io -y
#     sudo docker run -d -p 3000:3000 grafana/grafana
#     sudo docker run -d -p 9090:9090 prom/prometheus
# EOF

# }


# resource "aws_security_group" "metrics_sg" {
#   count = var.use_vpc ? 1 : 0

#   name        = "metrics-sg"
#   description = "Allow HTTP and SSH"
#   vpc_id      =  local.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = [aws_security_group.alb_sg[0].id]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# resource "aws_route53_record" "metrics_dns" {
#   zone_id = data.terraform_remote_state.domain.outputs.route53_zone.id
#   name    = "metrics.${var.domain_name}.${var.tld}"
#   type    = "A"

#   alias {
#     name                   = aws_lb.alb.dns_name
#     zone_id                = aws_lb.alb.zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_lb_target_group_attachment" "tg_metrics_attachment" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = aws_instance.metrics.id
#   port             = 80
# }