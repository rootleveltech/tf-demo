# Additional variables for enhanced configuration
variable "enable_monitoring" {
  description = "Enable monitoring configuration"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default = {
    "ManagedBy" = "Burrito"
    "Project"   = "TagSupportDemo"
  }
}

variable "retention_days" {
  description = "Number of days to retain configuration files"
  type        = number
  default     = 30
}
