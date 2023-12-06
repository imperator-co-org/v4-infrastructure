resource "aws_key_pair" "devbox" {
  count = var.create_devbox ? 1 : 0
  key_name   = "${var.environment}-indexer-devbox"
  public_key = var.devbox_public_key
}
