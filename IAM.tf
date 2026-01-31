############################################################
# DATA SOURCES (Dynamic Account + Region)
############################################################

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_instance_role" {
  name = "asg-ec2-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

############################################################
# CUSTOM POLICY: ALLOW SSM SESSION LOGGING TO CLOUDWATCH
############################################################

resource "aws_iam_policy" "ssm_logging_policy" {
  name        = "ssm-session-logging-policy-${var.env}"
  description = "Allow SSM sessions to write logs into CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.ssm_sessions.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_logging_attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ssm_logging_policy.arn
}

############################################################
# CUSTOM POLICY: SECRETS MANAGER ACCESS (INLINE JSON FILE)
############################################################

resource "aws_iam_policy" "secrets_policy" {
  name        = "asg-secrets-policy-${var.env}"
  description = "Allow EC2 instances to read specific RDS secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadRDSSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:us-east-1:739786453678:secret:lab/rds/mysql*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "asg-instance-profile-${var.env}"
  role = aws_iam_role.ec2_instance_role.name
}

############################################################
# IAM POLICY: ALLOW EC2/ASG TO READ THIS SECRET ONLY
############################################################

resource "aws_iam_policy" "ec2_read_rds_secret" {
  name        = "ec2-read-rds-secret-${var.env}"
  description = "Allow EC2 instances to read only lab/rds/mysql secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadSpecificSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret_version.rds_mysql_version.arn
      }
    ]
  })
}

############################################################
# ATTACH POLICY TO EC2 INSTANCE ROLE
############################################################

resource "aws_iam_role_policy_attachment" "attach_secret_access" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ec2_read_rds_secret.arn
}
