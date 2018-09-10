resource "aws_iam_role" "deploy_role" {
  name = "deploy_role_${var.git_project}-${var.stack}"

  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "deploy_policy_attachment" {
  name = "deploy_policy_attachment_${var.git_project}-${var.stack}"
  policy_arn = "${aws_iam_policy.deploy_policy.arn}"
  roles = ["${aws_iam_role.deploy_role.name}"]

}
resource "aws_iam_policy" "deploy_policy" {
  name = "deploy_policy_${var.git_project}-${var.stack}"
  policy = "${data.aws_iam_policy_document.deploy_role_policy_document.json}"
}
resource "aws_iam_instance_profile" "deploy_profile" {
  name = "deploy_profile_${var.git_project}_${var.stack}"
  role = "${aws_iam_role.deploy_role.name}"
}

data "aws_iam_policy_document" "deploy_role_policy_document" {
  "statement" {
    actions = [
      "s3:*",
      "cloudwatch:*",
      "logs:*",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.s3_bucket_deploy_artefact.arn}",
      "${aws_s3_bucket.s3_bucket_deploy_artefact.arn}/*",
      "${aws_cloudwatch_log_group.docker_logs.arn}",
      "arn:aws:logs:*:*:*"
    ]
  }
}
resource "aws_cloudwatch_log_group" "docker_logs" {
  name              = "${var.stack}-${var.git_project}-${var.environment}"
  retention_in_days = "7"
}