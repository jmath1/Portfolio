resource "aws_instance" "portfolio" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.portfolio_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io docker-compose git
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
    git clone https://github.com/jmath1/portfolio.git /home/ubuntu/portfolio
    cd /home/ubuntu/portfolio
    docker-compose up -d --build
  EOF

  tags = {
    Name = "portfolio-server"
  }
}

resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio_sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
