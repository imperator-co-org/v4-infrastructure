resource "aws_budgets_budget" "total" {
  name              = "aws-total-expense"
  budget_type       = "COST"
  limit_amount      = var.budget_total_amount_per_month
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_subscriber_email
  }
}
