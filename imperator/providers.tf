# Default provider.
provider "aws" {
  region = "ap-northeast-1"
}

# AWS region providers.
provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}
