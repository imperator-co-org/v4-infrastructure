resource "aws_security_group" "devbox" {
  count = var.create_devbox ? 1 : 0
  name   = "${var.environment}-devbox-sg"
  vpc_id = var.devbox_vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # For outgoing traffic, allow all.
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-devbox-sg"
    Environment = var.environment
  }
}
