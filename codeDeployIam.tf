resource "aws_iam_policy" "GH-Upload-To-S3" {
  name        = "GH-Upload-To-S3"
  description = "allows GitHub Actions to upload artifacts"

  policy = <<EOT
{
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOT
}

resource "aws_iam_policy" "GH-Code-Deploy" {
  name        = "GH-Code-Deploy"
  description = "allows GitHub Actions to call CodeDeploy APIs"

  policy = <<EOT
{"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:us-east-1:254269847591:application:csye6225-webapp"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:us-east-1:254269847591:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:us-east-1:254269847591:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:us-east-1:254269847591:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOT
}

resource "aws_iam_policy" "CodeDeploy-EC2-access" {
  name        = "CodeDeploy-EC2-access"
  description = "allows GitHub Actions to upload artifacts"

  policy = <<EOT
{
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "autoscaling:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "GH-Upload-To-S3-attach" {
  user       = "ghactions-app"
  policy_arn = aws_iam_policy.GH-Upload-To-S3.arn
}

resource "aws_iam_user_policy_attachment" "GH-Code-Deploy-attach" {
  user       = "ghactions-app"
  policy_arn = aws_iam_policy.GH-Code-Deploy.arn
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.CodeDeployServiceRole.name
  policy_arn = aws_iam_policy.CodeDeploy-EC2-access.arn
}

resource "aws_iam_role" "CodeDeployServiceRole" {
  name = "CodeDeployServiceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}