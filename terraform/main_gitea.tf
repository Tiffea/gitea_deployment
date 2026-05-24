#-----------------------configuration-----------------------------------------------#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}
#area of responsability
provider "aws" {
  region = "il-central-1"
}
#####################################################

#-------------server hardware and software configuration-------------------------#
resource "aws_instance" "gitea-server" {
  ami                    = "ami-0506b59d9221d1dfe" #(need backets) find using sn aws doc/aws ec2 launch instance or a terraform plugin
  instance_type          = "t3.small"              #basic and free version
  vpc_security_group_ids = [aws_security_group.gitea_sg.id]
  key_name               = "gitea_key"
  tags = {
    Name    = "gitea-server"
    Project = "yes"
  }
}
#-------------------set security group rules---------------------------------------#
resource "aws_security_group" "gitea_sg" {
  name        = "gitea-secgroup"
  description = "this is what these rules are about..."
  #SHH for connection
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #anyone can get it
  }
  #app itself
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #for http connection(without ssl certificate)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #for https connection(with ssl certificate)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #server can use any kind of protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#-----------------------------elactic ip-----------------------------------------#
resource "aws_eip" "gitea-server_eip" {
  instance = aws_instance.gitea-server.id

  tags = {
    Name = "gitea_eip"
  }
}
output "new_server_ip" {
  value = aws_eip.gitea-server_eip.public_ip
}

#----------------------------secret key for server connection---------------------#
resource "aws_key_pair" "gitea_key" {
  key_name   = "gitea_key"
  public_key = file("~/.ssh/gitea_key.pub")
}



# you need to set required_providers and required_version - terraform
#"~> 5.92" means 5.92 or higher up to 6.0
#check pipeline is working