data "aws_ami" "amazon-linux-ami" {
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.03.0.20200206.0-x86_64-gp2*"]
  }
  owners = ["amazon"] # Amazon
}
