variable "environment" {
  type        = string
  description = "Name of the environment {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | testnet9}."

  validation {
    condition = contains(
      ["dev", "dev2", "dev3", "dev4", "dev5", "staging", "testnet", "public-testnet", "testnet1", "testnet2", "testnet9", "mainnet"],
      var.environment
    )
    error_message = "Err: invalid environment. Must be one of {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | testnet9 | mainnet}."
  }
}
variable "devbox_subnet_id" {
  description = "Subnet ID for DevBox instance, a public subnet is required in this scenario"
  type        = string
  default     = ""
}
variable "devbox_vpc_id" {
  description = "VPC id to provision DevBox"
  type        = string
  default     = ""
}
variable "create_devbox" {
  description = "Create DevBox to access private resources?"
  type        = bool
  default     = false
}
variable "devbox_public_key" {
  description = "Devbox ssh public key"
  type        = string
  default     = ""
}
variable "budget_total_amount_per_month" {
  description = "The amount of cost for whole infrastructure of indexer"
  default     = 25000
}
variable "budget_subscriber_email" {
  description = "List of emails to receive notification"
}
