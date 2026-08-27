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
        --output json |
      python3 -c '
import json
import sys

data = json.load(sys.stdin)

if not data:
    data = {}

print(json.dumps({
    "pipelineExecutionId": str(data.get("pipelineExecutionId", "")),
    "status": str(data.get("status", "")),
    "startTime": str(data.get("startTime", ""))
}))
'
    EOT
  ]

  depends_on = [
    aws_codepipeline.terraform_pipeline
  ]
}