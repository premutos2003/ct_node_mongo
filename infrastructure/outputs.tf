output "app_instance_ip" {
  value = "${aws_instance.instance.public_ip}"
}
output "app_instance_id" {
  value = "${aws_instance.instance.id}"
}
output "app_id" {
  value = "${var.git_project}"
}
output "stack" {
  value = "${var.stack}"
}
output "region" {
  value = "${var.region}"
}
output "id" {
  value = "${var.git_project}-${var.environment}"
}


