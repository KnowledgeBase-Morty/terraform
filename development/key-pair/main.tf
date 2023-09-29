resource "aws_key_pair" "md_dev_eb_keypair_uswest2" {
  key_name   = "md_eb_keypair_uswest2"
  public_key = file("${var.public_key_file_path}")
}
