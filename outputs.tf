output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "karpenter_iam_role_arn" {
  description = "ARN of the IAM role for Karpenter"
  value       = aws_iam_role.karpenter_controller.arn
}