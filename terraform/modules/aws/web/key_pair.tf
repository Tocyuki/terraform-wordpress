resource "aws_key_pair" "web" {
  key_name   = "${var.name}-${var.env}"
  public_key = file(var.key_pair_file_path)
}
