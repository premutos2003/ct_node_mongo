

resource "aws_s3_bucket_object" "deploy_artefact" {
  source = "./${var.git_project}.tar.gz"
  bucket = "${var.environment}-infra-base"
  key = "/apps/${var.stack}-${var.git_project}/artefact/${var.git_project}.tar.gz"
}


