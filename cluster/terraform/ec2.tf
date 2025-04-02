data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250305"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "worker1"
  }
}

resource "aws_instance" "worker2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "worker2"
  }
}

output master_ip {
    value = aws_instance.master.public_ip
}

output worker1_ip {
    value = aws_instance.worker1.public_ip
}

output worker2_ip {
    value = aws_instance.worker2.public_ip
}