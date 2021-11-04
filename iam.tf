resource "aws_iam_policy" "WebAppS3" {
  name        = "WebAppS3"
  description = "WebAppS3 policy"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:Put*",
                "s3:Delete*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOT
}

resource "aws_iam_role" "EC2-CSYE6225" {
  name = "EC2-CSYE6225"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "EC2-CSYE6225" {
  name = "EC2-CSYE6225"
  role = aws_iam_role.EC2-CSYE6225.name
}

resource "aws_iam_policy_attachment" "role-attach" {
  name       = "role-attachment"
  roles      = [aws_iam_role.EC2-CSYE6225.name]
  policy_arn = aws_iam_policy.WebAppS3.arn
}