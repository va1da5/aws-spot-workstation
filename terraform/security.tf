data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  tags = {
    Name = "spot-instances-ssh-allowed"
  }
}
