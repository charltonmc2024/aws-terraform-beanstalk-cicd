
##################################
# Elastic Beanstalk ALB Security Group
##################################

resource "aws_security_group" "eb_alb" {

  name = "${var.app_name}-eb-alb-sg"

  description = "Allow HTTP/HTTPS traffic to Elastic Beanstalk ALB"

  vpc_id = aws_vpc.main.id


  ##################################
  # HTTP from Internet
  ##################################

  ingress {

    description = "HTTP from Internet"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  ##################################
  # HTTPS from Internet
  ##################################

  ingress {

    description = "HTTPS from Internet"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  ##################################
  # Outbound
  ##################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  tags = {

    Name = "${var.app_name}-eb-alb-sg"

  }

}



##################################
# Elastic Beanstalk EC2 Security Group
##################################

resource "aws_security_group" "eb_ec2" {

  name = "${var.app_name}-eb-ec2-sg"

  description = "Allow Elastic Beanstalk instances traffic from ALB"

  vpc_id = aws_vpc.main.id


  ##################################
  # ALB -> EC2 Docker Container
  ##################################

  ingress {

    description = "HTTP from VPC"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.eb_alb.id
    ]

  }


  ##################################
  # Outbound Internet
  # Required for ECR image pull
  ##################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  tags = {

    Name = "${var.app_name}-eb-ec2-sg"

  }

}