resource "aws_instance" "ec2_instance" {
  ami                     = var.ami_id
  instance_type           = "t2.micro"
  disable_api_termination = false
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
  key_name  = "YYH"
  subnet_id = aws_subnet.subnet["us-east-1a"].id
  vpc_security_group_ids = [
    aws_security_group.application.id
  ]
  user_data = <<-EOF
  #cloud-boothook
  #! /bin/bash
  sudo apt-get update
  export TEST="TEST"
  export DATABASE_USERNAME=${var.db_username}
  export DATABASE_PASSWORD=${var.db_password}
  export DATABASE_HOSTNAME=${aws_db_instance.mysql_db_instance.endpoint}
  export S3_BUCKET_NAME=${var.bucket_name}
  EOF

  iam_instance_profile = "CloudWatchAgentServerRole"

  tags = {
    Name = "csye6225-EC2"
  }


}