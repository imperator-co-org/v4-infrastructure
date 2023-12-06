locals {
  user_data = <<EOH

#!/bin/bash
# Upgrade existing packages
sudo apt update && sudo apt -y upgrade
sudo apt install build-essential

# nvm (Node.js version manager)
wget -qO- <https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh> | bash
source ~/.bashrc

# Kafka (message bus)
sudo apt install -y default-jre
wget <https://archive.apache.org/dist/kafka/2.6.2/kafka_2.12-2.6.2.tgz>
tar -xzf kafka_2.12-2.6.2.tgz
rm kafka_2.12-2.6.2.tgz

# Redis
sudo apt install -y redis-server redis-tools

# PostgresSQL 12 (database
sudo sh -c 'echo "deb <http://apt.postgresql.org/pub/repos/apt> $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - <https://www.postgresql.org/media/keys/ACCC4CF8.asc> | sudo apt-key add -
sudo apt update && sudo apt install -y postgresql-12 postgresql-contrib
exit
EOH
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "devbox" {
  count = var.create_devbox ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.devbox[count.index].id]
  user_data              = local.user_data
  subnet_id              = var.devbox_subnet_id
  key_name = aws_key_pair.devbox[count.index].key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-indexer-devbox"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ami. These are updated frequently
      # and cause the EC2 instance to be destroyed with
      # new deploys.
      ami,
    ]
  }
  
  root_block_device {
    volume_size = 20
  }
}
