output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_1_id" {
  description = "Private subnet 1 IDs"
  value = [
    aws_subnet.private_1.id
  ]
}

output "private_subnet_2_id" {
  description = "Private subnet 2 IDs"
  value = [
    aws_subnet.private_2.id
  ]
}
output "public_subnet_1_id" {
  description = "Public subnet 1 IDs"
  value = [
    aws_subnet.public_1.id
  ]
}

output "public_subnet_2_id" {
  description = "Public subnet 2 IDs"
  value = [
    aws_subnet.public_2.id
  ]
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Elastic IP address assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.nginx.repository_url
}

output "codebuild_test_role_arn" {
  description = "IAM Role ARN for CodeBuild Test"
  value       = aws_iam_role.codebuild_test_role.arn
}

output "codebuild_build_role_arn" {
  description = "IAM Role ARN for CodeBuild Build"
  value       = aws_iam_role.codebuild_build_role.arn
}

output "codebuild_deploy_role_arn" {
  description = "IAM Role ARN for CodeBuild Deploy"
  value       = aws_iam_role.codebuild_deploy_role.arn
}

output "codebuild_test_project_name" {
  description = "CodeBuild Test Project Name"
  value       = aws_codebuild_project.test.name
}

output "codebuild_build_project_name" {
  description = "CodeBuild Build Project Name"
  value       = aws_codebuild_project.build.name
}

output "codebuild_deploy_project_name" {
  description = "CodeBuild Deploy Project Name"
  value       = aws_codebuild_project.deploy.name
}

output "github_connection_arn" {
  description = "ARN of the GitHub connection"
  value       = aws_codestarconnections_connection.github_connection.arn
}

output "s3_artifacts_bucket_name" {

  description = "S3 bucket name used to store Elastic Beanstalk deployment packages"

  value = aws_s3_bucket.codepipeline_artifact.bucket

}

output "elastic_beanstalk_environment_url" {
  description = "NGINX Beanstalk Environment URL"
  value       = "http://${aws_elastic_beanstalk_environment.nginx_env.cname}"
}

