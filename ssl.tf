resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.ssl_arn

  default_action {
    target_group_arn = aws_lb_target_group.alb_group.arn
    type             = "forward"
  }
}

# resource "aws_kms_key" "kms-key-ebs" {
#   description             = "KMS key for ebs"
#   enable_key_rotation = true
#   policy                  = <<POLICY
#   {
#     "Version": "2012-10-17",
#     "Statement": [{
#             "Sid": "Enable IAM User Permissions",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::254269847591:root"
#             },
#             "Action": "kms:*",
#             "Resource": "*"
#         },
#       {
#    "Sid": "Allow service-linked role use of the customer managed key",
#    "Effect": "Allow",
#    "Principal": {
#        "AWS": [
#            "arn:aws:iam::254269847591:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#        ]
#    },
#    "Action": [
#        "kms:Encrypt",
#        "kms:Decrypt",
#        "kms:ReEncrypt*",
#        "kms:GenerateDataKey*",
#        "kms:DescribeKey"
#    ],
#    "Resource": "*"
# },
# {
#    "Sid": "Allow attachment of persistent resources",
#    "Effect": "Allow",
#    "Principal": {
#        "AWS": [
#            "arn:aws:iam::254269847591:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#        ]
#    },
#    "Action": [
#        "kms:CreateGrant"
#    ],
#    "Resource": "*",
#    "Condition": {
#        "Bool": {
#            "kms:GrantIsForAWSResource": true
#        }
#     }
# }
#     ]
# }
# POLICY
# }

resource "aws_ebs_encryption_by_default" "ebs-encryption" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "ebs-encryption-key" {
  key_arn = "arn:aws:kms:us-east-1:254269847591:key/f45ca58c-ca50-4eaf-a56a-e9f349e2e826"
}

resource "aws_kms_key" "kms-key-rds" {
  description             = "KMS key for rds"
}
