packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "web" {
  region               = "us-east-1"
  source_ami           = "ami-0aacbf72109c53c0c"
  instance_type        = "t3.micro"
  ssh_username         = "ec2-user"
  ssh_interface        = "session_manager"
  iam_instance_profile = "LabInstanceProfile"

  subnet_id = "subnet-024ef07de6aa7cadc"

  ami_name = "acs730-lab6-golden-{{timestamp}}"

  tags = {
    Name    = "acs730-lab6-golden"
    Project = "acs730-lab6"
  }
}

build {
  sources = ["source.amazon-ebs.web"]

  provisioner "file" {
    source      = "files/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "sudo dnf install -y httpd",
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo chown root:root /var/www/html/index.html",
      "sudo chmod 0644 /var/www/html/index.html",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]
  }
}
