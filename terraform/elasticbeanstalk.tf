##################################
# Elastic Beanstalk Application
##################################

resource "aws_elastic_beanstalk_application" "nginx" {
  name        = "${var.app_name}-terraform"
  description = "NGINX Docker application deployed by Terraform CI/CD"
}

##################################
# Elastic Beanstalk Environment
##################################

resource "aws_elastic_beanstalk_environment" "nginx_env" {
  name        = "${var.app_name}-production-env"
  application = aws_elastic_beanstalk_application.nginx.name

  cname_prefix = "charlton-cicd-beanstalk-project"




  ##################################
  # Docker Platform
  ##################################

  platform_arn = "arn:aws:elasticbeanstalk:${var.aws_region}::platform/Docker running on 64bit Amazon Linux 2023/4.13.4"

  ##################################
  # EC2 Instance Profile
  ##################################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  ##################################
  # EC2 Instance Type
  ##################################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  ##################################
  # EC2 Security Group
  ##################################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_ec2.id
  }

  ##################################
  # VPC
  ##################################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  ##################################
  # Elastic Beanstalk EC2 Subnets
  ##################################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value = join(",", [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ])
  }

  ##################################
  # Load Balancer Subnets
  ##################################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value = join(",", [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id
    ])
  }

  ##################################
  # Load Balanced Environment
  ##################################

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  ##################################
  # ALB Security Group
  ##################################

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_alb.id
  }

  ##################################
  # Health Check
  ##################################

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/"
  }

  ##################################
  # Rolling Deployment
  ##################################

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  ##################################
  # Enable CloudWatch Logs
  ##################################

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  ##################################
  # Log Retention
  ##################################

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  ##################################
  # CodePipeline controls versions
  ##################################

  lifecycle {
    ignore_changes = [version_label]
  }
}
