# create an ec2 instance that will have docker containers for prometheus and grafana that will have the metrics for the web application and rds


resource "aws_instance" "metrics" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = local.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.metrics_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF

    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install docker.io -y
    sudo docker run -d -p 3000:3000 grafana/grafana
    sudo docker run -d -p 9090:9090 prom/prometheus
EOF

}


resource "aws_security_group" "metrics_sg" {
  name        = "metrics-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

    