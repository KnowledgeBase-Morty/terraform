resource "aws_codestarconnections_connection" "github_connection" {
  name          = "mortensen-development-connection"
  provider_type = "GitHub"
}
