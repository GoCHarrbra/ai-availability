variable "subscription_id" {
  type        = string
  description = "Azure subscription to target."
}

variable "rg_name" {
  type        = string
  description = "Resource group where AI, Web Test, Action Group, and Alert will be created."
}

variable "location" {
  type        = string
  description = "Azure region for the AI/WebTest/Alert resources (e.g., canadacentral)."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming (e.g., tfhero)."
}

variable "law_rg_name" {
  type        = string
  description = "Resource group of the existing Log Analytics Workspace."
}

variable "law_name" {
  type        = string
  description = "Name of the existing Log Analytics Workspace."
}

variable "backend_health_url" {
  type        = string
  description = "Public health URL to probe, e.g. https://myapp.example.com/health"
}

variable "alert_emails" {
  type        = list(string)
  description = "Email recipients for the Action Group."
}

variable "app_name" {
  type        = string
  description = "Logical app name to show in alert titles."
}

variable "alert_severity" {
  type        = number
  description = "Alert severity (0-4)."
}

variable "web_test_frequency_seconds" {
  type        = number
  description = "Web test frequency in seconds; must be one of 300, 600, 900."
  validation {
    condition     = contains([300, 600, 900], var.web_test_frequency_seconds)
    error_message = "web_test_frequency_seconds must be 300, 600, or 900."
  }
}

variable "web_test_geo_locations" {
  type        = list(string)
  description = "List of Web Test geo location IDs (e.g., us-va-ash-azr)."
}

variable "alert_failed_locations_threshold" {
  type        = number
  description = "Fire alert if failed locations >= this number within the evaluation window."
}

# REQUIRED: KQL must be supplied by the caller via tfvars (no default here)
variable "kql_query" {
  type        = string
  description = "KQL used by the Scheduled Query Alert v2."
  validation {
    condition     = length(trim(var.kql_query)) > 0
    error_message = "kql_query cannot be empty; provide it in your tfvars."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
  default     = {}
}
