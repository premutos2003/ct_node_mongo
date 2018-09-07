
  resource "aws_s3_bucket" "s3_bucket_deploy_artefact" {
    bucket = "test-bucket-87778189"
    force_destroy = true
    region = "eu-west-1"

  }
  resource "aws_s3_bucket_object" "deploy_artefact" {
    source = "artefact.tar.gz"
    bucket = "${aws_s3_bucket.s3_bucket_deploy_artefact.id}"
    key = "artefact.tar.gz"
  }




