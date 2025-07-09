# Output configurations for production monitoring
output "deployment_info" {
  description = "Deployment information for monitoring"
  value = {
    environment     = var.environment
    project_name    = var.project_name
    monitoring      = var.enable_monitoring
    retention_days  = var.retention_days
    tags           = var.tags
    config_file    = local_file.config.filename
  }
}

output "terraform_version" {
  description = "Terraform version used for deployment"
  value = {
    version = "1.5.0+"
    provider_versions = {
      local = "~> 2.4"
    }
  }
}
