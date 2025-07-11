# Test Terraform configuration for Burrito tag support
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "burrito-test-PR"
}

# Create a simple local file to demonstrate infrastructure
resource "local_file" "config" {
  content = templatefile("${path.module}/templates/config.tpl", {
    environment  = var.environment
    project_name = var.project_name
    timestamp    = timestamp()
  })
  filename = "${path.module}/outputs/config-${var.environment}.txt"
}

# Output the file path
output "config_file_path" {
  value = local_file.config.filename
}

output "environment" {
  value = var.environment
}

output "project_name" {
  value = var.project_name
}
# Test change to trigger Burrito PR workflow
