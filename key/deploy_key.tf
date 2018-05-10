resource "null_resource" "ssh-key" {

  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -f './base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa' -N ''"
  }
  provisioner "local-exec" {
    command = "chmod 777 base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa"
  }
  provisioner "local-exec" {
    command = "chmod 777 base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa.pub"
  }
}

/* Upload plain public key to S3 bucket. */

resource "aws_s3_bucket_object" "ec2-ssh-public-key" {
  depends_on = ["null_resource.ssh-key","aws_s3_bucket.secrets_bucket"]
  key        = "base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_ssh.pub"
  bucket     = "${aws_s3_bucket.secrets_bucket.id}"
  source     = "./base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa.pub"
  kms_key_id = "${var.kms_key_arn}"
  content_type = "text/*"

}

resource "null_resource" "private-key-encrypt" {

  depends_on = ["null_resource.ssh-key"]

  provisioner "local-exec" {
    command = "ls"
  }
  provisioner "local-exec" {
    command = "aws kms encrypt --region ${var.region} --key-id ${var.kms_key_arn} --plaintext=fileb://base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa --output text --query CiphertextBlob | base64  --decode > base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa_encrypted"
  }

}

/* Upload encrypted private key to S3 bucket. */

resource "aws_s3_bucket_object" "ec2-ssh-private-key" {

  depends_on = ["null_resource.private-key-encrypt","aws_s3_bucket.secrets_bucket"]
  key        = "base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_ssh_private_key_encrypted"
  bucket     = "${aws_s3_bucket.secrets_bucket.id}"
  source     = "./base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa_encrypted"
  kms_key_id = "${var.kms_key_arn}"
  content_type = "text/*"

}

/* Access public key as data source */

data "aws_s3_bucket_object" "ssh-public-key" {
  bucket = "${aws_s3_bucket.secrets_bucket.id}"
  key = "${aws_s3_bucket_object.ec2-ssh-public-key.id}"
}

/* Create key pair resource */

resource "aws_key_pair" "key" {
  key_name                  = "base_${var.stack}_${var.git_project}_${var.environment}_${var.region}"
  public_key                = "${data.aws_s3_bucket_object.ssh-public-key.body}"

  lifecycle {
    create_before_destroy               = true
  }

}

resource "aws_s3_bucket" "secrets_bucket" {
  bucket = "${var.stack}-${var.git_project}-${var.environment}-${var.region}-secrets"
  region = "${var.region}"
}

locals {
  pkey= "base_${var.stack}_${var.git_project}_${var.environment}_${var.region}_id-rsa"
}