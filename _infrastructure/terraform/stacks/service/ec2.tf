
resource "aws_instance" "portfolio" {
  ami                  = "ami-04b4f1a9cf54c11d0"
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.portfolio_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -ex

    apt update -y
    apt install -y docker.io git nginx awscli unzip

    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # Clone the repository and start the Docker container
    git clone https://github.com/jmath1/portfolio.git /home/ubuntu/portfolio
    cd /home/ubuntu/portfolio
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${local.ecr_repository_url}
    docker pull ${local.ecr_repository_url}:latest
    docker run -d --network host ${local.ecr_repository_url}:latest

    # Configure Nginx as a reverse proxy for the Docker container
    cat <<EOF_NGINX > /etc/nginx/sites-available/portfolio
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://127.0.0.1:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    EOF_NGINX

    # Enable Nginx site and restart Nginx
    ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
    systemctl restart nginx
    systemctl enable nginx
  EOF

  tags = {
    Name = "portfolio-server"
  }
}


resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio_sg"
  description = "Allow HTTPS and SSH"

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