##################################
# Elastic Beanstalk EC2 Role
##################################

resource "aws_iam_role" "eb_ec2_role" {
  name = "${var.app_name}-elasticbeanstalk-ec2-role"

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


###################################
# Elastic Beanstalk Web Tier Access
###################################

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}


###################################
# Elastic Beanstalk ECR Pull Access
###################################

resource "aws_iam_role_policy_attachment" "eb_ecr_read" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


####################################
# Elastic Beanstalk Instance Profile
####################################

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "${var.app_name}-elasticbeanstalk-ec2-profile"

  role = aws_iam_role.eb_ec2_role.name
}


