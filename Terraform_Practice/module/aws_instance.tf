resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = local.primary_public_subnet

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-web-server"
  }
}