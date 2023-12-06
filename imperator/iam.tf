module "iam_github_actions" {
  source      = "../modules/iam/github_actions_role"
  name        = "validator"
  environment = var.environment
  ecr_repository_arns = [
    "arn:aws:ecr:us-east-2:${local.account_id}:repository/${var.environment}-validator",
    "arn:aws:ecr:us-east-2:${local.account_id}:repository/${var.environment}-validator-snapshot",
    "arn:aws:ecr:us-east-2:${local.account_id}:repository/${var.environment}-orb"
  ]
  lambda_arns = []
  assume_iam_roles = []
}
