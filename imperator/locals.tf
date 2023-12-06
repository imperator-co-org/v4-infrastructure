data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  provider = var.environment == "mainnet" ? aws.ap-northeast-1 : aws.us-east-2
}
