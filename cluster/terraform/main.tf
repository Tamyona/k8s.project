provider "aws" {
    region = "us-east-2"
}

resource "aws_key_pair" "rke_key" {
    key_name = "rke-key"
    public_key = file("~/.ssh/id_rsa.pub")
}