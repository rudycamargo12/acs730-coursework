data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[local.subnet_names[0]].id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-USERDATA
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    echo "<h1>ACS730 Lab 5 - Terraform Web Server</h1>" > /var/www/html/index.html
    systemctl start httpd
  USERDATA

  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public
  ]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-web"
  })
}
