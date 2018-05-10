resource "aws_s3_bucket" "s3_bucket_deploy_artefact" {
  bucket = "${var.stack}-${var.git_project}"
  force_destroy = true
  acl = "private"
  region = "${var.region}"

}
resource "aws_s3_bucket_object" "deploy_artefact" {
  source = "./${var.git_project}.tar.gz"
  bucket = "${aws_s3_bucket.s3_bucket_deploy_artefact.id}"
  key = "${var.stack}-${var.git_project}/${var.version}.tar.gz"
}




