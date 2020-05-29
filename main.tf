data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["*RHEL-7.3_HVM_GA-*"]
  }
}

provider "aws" {
}

resource "random_id" "name" {
  byte_length = 4
}

resource "aws_key_pair" "awskey" {
  key_name   = "awskwy-${random_id.name.hex}"
  public_key = tls_private_key.awskey.public_key_openssh
}

resource "aws_security_group" "allow_all" {
  name        = "rc-security-group-${random_id.name.hex}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  count                   = var.instance_count
  ami                     = data.aws_ami.rhel_ami.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.awskey.key_name
  security_groups = ["${aws_security_group.allow_all.name}"]

  tags = {
    Name        = var.name
    TTL         = var.ttl
    Owner       = var.owner
    Description = "This branch updated v6"
  }
}
