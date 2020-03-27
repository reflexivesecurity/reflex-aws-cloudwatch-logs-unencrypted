module "reflex_aws_cloudwatch_logs_unencrypted" {
  source           = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe_lambda?ref=v0.5.4"
  rule_name        = "CloudWatchLogsUnencrypted"
  rule_description = "A Reflex Rule for detecting CloudWatch Logs that are unencrypted"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.logs"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "logs.amazonaws.com"
    ],
    "eventName": [
      "CreateLogGroup",
      "DisassociateKmsKey"
    ]
  }
}
PATTERN

  function_name   = "CloudWatchLogsUnencrypted"
  source_code_dir = "${path.module}/source"
  handler         = "reflex_aws_cloudwatch_logs_unencrypted.lambda_handler"
  lambda_runtime  = "python3.7"
  environment_variable_map = {
    SNS_TOPIC = var.sns_topic_arn
  }
  custom_lambda_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:DescribeLogGroups"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  queue_name    = "CloudWatchLogsUnencrypted"
  delay_seconds = 0

  target_id = "CloudWatchLogsUnencrypted"

  sns_topic_arn  = var.sns_topic_arn
  sqs_kms_key_id = var.reflex_kms_key_id
}
