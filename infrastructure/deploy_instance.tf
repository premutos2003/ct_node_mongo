resource "aws_instance" "instance" {
  depends_on = ["aws_s3_bucket_object.deploy_artefact","aws_iam_policy.deploy_policy"]
  ami = "ami-d3c022bc"

  key_name = "base_${var.stack}_${var.git_project}_${var.environment}"

  vpc_security_group_ids = ["${var.sec_gp_id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("${path.module}/docker-compose.yml")}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.deploy_profile.name}"

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user = "ec2-user"
      host = "${aws_instance.instance.public_ip}"
      private_key =  "${file("../key/base_${var.stack}_${var.git_project}_${var.environment}_id-rsa")}"
    }
    inline = [
      "pip install --upgrade awscli",
      "pip install docker-compose",
      "export PATH=/home/ec2-user/.local/bin:$PATH",
      "aws --version",
      //"sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "echo s3://${aws_s3_bucket.s3_bucket_deploy_artefact.bucket}/${aws_s3_bucket_object.deploy_artefact.key} ./ ",
      "aws s3 ls s3://${aws_s3_bucket.s3_bucket_deploy_artefact.bucket} --region eu-central-1",
      "mkdir artefact",
      "ls",
      "aws s3 cp s3://${aws_s3_bucket.s3_bucket_deploy_artefact.bucket}/${aws_s3_bucket_object.deploy_artefact.key} ./artefact --region ${var.region}",
      "ls",
      "ls ./artefact",
      "whoami",
    ]

   }


  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user = "ec2-user"
      host = "${aws_instance.instance.public_ip}"
      //private_key = "${file(local.pkey)}"
      private_key =  "${file("../key/base_${var.stack}_${var.git_project}_${var.environment}_id-rsa")}"
    }

    inline = [
      "docker images",
      "export PORT=${var.port}",
      "export PROJECT_NAME=${var.git_project}",
      "gunzip ./artefact/${var.version}.tar.gz",
      "docker load < ./artefact/${var.version}.tar",
      "docker-compose up -d"
    ]
  }
}



