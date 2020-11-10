data "aws_ami" "web" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.name}-${var.env}-web-ami-*"]
  }
}

# data "aws_ami" "web" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "block-device-mapping.volume-type"
#     values = ["gp2"]
#   }
# }
