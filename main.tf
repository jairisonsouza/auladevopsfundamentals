provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "devops_sg" {
  name_prefix = "devops-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "devops_vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.devops_key.key_name
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }

    inline = [
      "sudo apt update -y",
      "sudo apt install -y git curl unzip docker.io docker-compose",
      "sudo usermod -aG docker ubuntu",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo apt-add-repository 'deb http://apt.kubernetes.io/ kubernetes-xenial main'",
      "sudo apt update -y",
      "sudo apt install -y kubectl",
      "git clone https://github.com/jairisonsouza/adiantiframework.git ~/adianti",
      "cd ~/adianti && sudo docker-compose up -d"
    ]
  }

  tags = {
    Name = "DevOps-VM"
  }
}
