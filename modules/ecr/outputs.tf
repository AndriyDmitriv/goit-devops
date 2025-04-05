output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "repository_name" {
  description = "Name of the created ECR repository"
  value       = aws_ecr_repository.ecr_repo.name
}
