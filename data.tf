data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners   = ["amazon"]
}

data "aws_iam_role" "ec2_iam_role" {
  name = "ec2-codedeployer"
}

data "cloudinit_config" "user_data" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.root}/configurations/user-data.sh")
  }

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = filebase64("${path.root}/configurations/backend")
          path        = "/etc/nginx/sites-available/backend"
          owner       = "ubuntu:ubuntu"
          permissions = "0644"
        },
      ]
    })
  }
}
