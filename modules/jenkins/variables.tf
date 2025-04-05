
variable "cluster_name" {
  description = "Назва кластера"
  type        = string
}
variable "namespace" {
  description = "Kubernetes namespace for deploying Jenkins"
  type        = string
  default     = "jenkins"
}
variable "oidc_provider_arn" {
  description = "OIDC provider ARN from EKS cluster"
  type        = string
}
variable "oidc_provider_url" {
  type = string
}
