# Container Registry where the container image for full nodes that upload periodic snapshots
# are published.
resource "aws_ecr_repository" "snapshot" {
  count                = var.environment == "mainnet" ? 0 : 1
  provider             = aws.us-east-2
  name                 = "${var.environment}-validator-snapshot"
  image_tag_mutability = "MUTABLE" # MUTABLE to use "latest" tag

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "snapshot" {
  count      = var.environment == "mainnet" ? 0 : 1
  provider   = aws.us-east-2
  repository = aws_ecr_repository.snapshot[count.index].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}

# Container Registry where validator container images are published.
resource "aws_ecr_repository" "main" {
  count                = var.environment == "mainnet" ? 0 : 1
  provider             = aws.us-east-2
  name                 = "${var.environment}-validator"
  image_tag_mutability = "MUTABLE" # MUTABLE to use "latest" tag

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "main" {
  count      = var.environment == "mainnet" ? 0 : 1
  provider   = aws.us-east-2
  repository = aws_ecr_repository.main[count.index].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}

resource "aws_ecr_repository" "snapshot_ap_northeast" {
  count                = var.environment == "mainnet" ? 1 : 0
  provider             = aws.ap-northeast-1
  name                 = "${var.environment}-validator-snapshot"
  image_tag_mutability = "MUTABLE" # MUTABLE to use "latest" tag

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "snapshot_ap_northeast" {
  count      = var.environment == "mainnet" ? 1 : 0
  provider   = aws.ap-northeast-1
  repository = aws_ecr_repository.snapshot[count.index].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}

# Container Registry where validator container images are published.
resource "aws_ecr_repository" "main_ap_northeast" {
  count                = var.environment == "mainnet" ? 1 : 0
  provider             = aws.ap-northeast-1
  name                 = "${var.environment}-validator"
  image_tag_mutability = "MUTABLE" # MUTABLE to use "latest" tag

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "main_ap_northeast" {
  count      = var.environment == "mainnet" ? 1 : 0
  provider   = aws.ap-northeast-1
  repository = aws_ecr_repository.main[count.index].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}
