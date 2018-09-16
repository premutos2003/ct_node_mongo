resource "aws_instance" "instance" {
  depends_on = ["aws_s3_bucket_object.deploy_artefact","aws_iam_policy.deploy_policy"]
  ami = "${data.aws_ami.ami.id}"
  key_name = "base_${var.stack}_${var.git_project}_${var.environment}"

  vpc_security_group_ids = ["${var.sec_gp_id}"]
  subnet_id = "${var.subnet_id}"
  user_data = <<-EOF
               PORT="${var.port}"
               PROJECT_NAME="${var.git_project}"
              EOF
  instance_type = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.deploy_profile.name}"
  provisioner "file" {
      connection {
        type     = "ssh"
        user = "ec2-user"
        host = "${aws_instance.instance.public_ip}"
        private_key =  "${file("../key/base_${var.stack}_${var.git_project}_${var.environment}_id-rsa")}"
      }
    source = "../../docker-compose.yml"
    destination = "./docker-compose.yml"
  }
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
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo usermod -a -G docker ec2-user",
      "sudo chkconfig docker on",
      "sudo service docker start",
      "echo s3://${var.environment}-infra-base${aws_s3_bucket_object.deploy_artefact.key} ./ ",
      "mkdir artefact",
      "aws s3 cp s3://${var.environment}-infra-base/${aws_s3_bucket_object.deploy_artefact.key} ./artefact",
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
      "sudo docker images",
      "export PORT=${var.port}",
      "export PROJECT_NAME=${var.git_project}",
      "export LOG_GROUP=${var.stack}-${var.git_project}-${var.environment}",
      "export REGION=${var.region}",
      "gunzip ./artefact/${var.version}.tar.gz",
      "sudo docker load < ./artefact/${var.version}.tar",
      "docker-compose up -d"
    ]
  }

}



data "aws_ami" "ami" {
  most_recent = true

  # ubuntu ami account ID
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn-ami-hvm-????.??.?.????????-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}
