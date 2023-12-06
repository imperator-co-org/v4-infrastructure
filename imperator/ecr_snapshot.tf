# Container Registry where the container image for full nodes that upload periodic snapshots
# are published.
resource "aws_ecr_repository" "snapshot" {
  provider             = aws.us-east-2
  name                 = "${var.environment}-validator-snapshot"
  image_tag_mutability = "MUTABLE" # MUTABLE to use "latest" tag

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "snapshot" {
  provider   = aws.us-east-2
  repository = aws_ecr_repository.snapshot.name

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
