resource "aws_instance" "instance" {
  depends_on = ["aws_s3_bucket_object.deploy_artefact","aws_iam_policy.deploy_policy"]
  ami = "ami-d3c022bc"

  key_name = "base_${var.stack}_${var.git_project}_${var.environment}"

  vpc_security_group_ids = ["${var.sec_gp_id}"]
  subnet_id = "${var.subnet_id}"

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
      "docker pull mvertes/alpine-mongo",
      "docker run -d -p 27017:27017 mvertes/alpine-mongo"
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
      "gunzip ./artefact/${var.version}.tar.gz",
      "docker load < ./artefact/${var.version}.tar",
      "docker run -d -p 80:${var.port} --add-host ${var.git_project}:${aws_instance.instance.public_ip}  ${var.git_project}:latest"
    ]
  }
}



