resource "aws_s3_bucket" "s3_bucket_deploy_artefact" {
  bucket = "${var.stack}-${var.git_project}-docker-artefact"
  force_destroy = true
  acl = "private"
  region = "${var.region}"cd

}
resource "aws_s3_bucket_object" "deploy_artefact" {
  source = "./${var.git_project}.tar.gz"
  bucket = "${aws_s3_bucket.s3_bucket_deploy_artefact.id}"
  key = "${var.stack}-${var.git_project}/${var.version}.tar.gz"
}




