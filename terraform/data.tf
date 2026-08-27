data "aws_caller_identity" "current" {}

data "external" "codepipeline_execution" {
  program = [
    "bash",
    "-c",
    <<-EOT
      aws codepipeline list-pipeline-executions \
        --pipeline-name "${aws_codepipeline.terraform_pipeline.name}" \
        --region "${var.aws_region}" \
        --query 'pipelineExecutionSummaries[0]' \
        --output json
    EOT
  ]
}