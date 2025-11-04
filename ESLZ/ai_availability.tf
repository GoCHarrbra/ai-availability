terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# -------------------------
# Variables (multi-line)
# -------------------------

variable "subscription_id" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "law_rg_name" {
  type = string
}

variable "law_name" {
  type = string
}

variable "backend_health_url" {
  type        = string
  description = "Public health URL to probe, e.g. https://myapp/health"
}

variable "web_test_name" {
  type        = string
  description = "The exact AI Standard Web Test name. Your KQL should use this same value in Name == \"...\""
}

variable "web_test_frequency_seconds" {
  type = number
  validation {
    condition     = contains([300, 600, 900], var.web_test_frequency_seconds)
    error_message = "web_test_frequency_seconds must be one of 300, 600, 900."
  }
}

variable "web_test_geo_locations" {
  type        = list(string)
  description = "Standard Web Test location IDs (e.g., us-va-ash-azr, us-ca-sjc-azr, emea-gb-db3-azr)"
}

variable "alert_emails" {
  type        = list(string)
  description = "List of email recipients for the Action Group."
}

variable "app_name" {
  type = string
}

variable "alert_severity" {
  type        = number
  description = "0..4 (0 is Sev0)"
}

variable "alert_failed_locations_threshold" {
  type        = number
  description = "Alert when failed locations >= this threshold in the window."
}

variable "kql_query" {
  type        = string
  description = <<DESC
KQL must produce exactly one numeric column with the name in kql_measure_column.
Example:

AppAvailabilityResults
| where Name == "<your-web-test-name>"
| where TimeGenerated > ago(5m)
| summarize AggregatedValue = toreal(dcountif(Location, Success == false))
| project AggregatedValue
DESC
}

variable "kql_measure_column" {
  type        = string
  description = "The exact numeric column name that your KQL outputs (e.g., AggregatedValue)."
}

# -------------------------
# Ensure target RG exists
# -------------------------
resource "azurerm_resource_group" "monitoring" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

# -------------------------
# Module call
# -------------------------
module "ai_webtest_alert" {
  source = "github.com/0x4849/ai-availability.git?ref=v0.5.0"

  rg_name     = azurerm_resource_group.monitoring.name
  location    = var.location
  name_prefix = var.name_prefix
  env         = var.env
  tags        = var.tags

  law_rg_name = var.law_rg_name
  law_name    = var.law_name

  backend_health_url         = var.backend_health_url
  web_test_name              = var.web_test_name
  web_test_frequency_seconds = var.web_test_frequency_seconds
  web_test_geo_locations     = var.web_test_geo_locations

  alert_emails                     = var.alert_emails
  app_name                         = var.app_name
  alert_severity                   = var.alert_severity
  alert_failed_locations_threshold = var.alert_failed_locations_threshold

  kql_query          = var.kql_query
  kql_measure_column = var.kql_measure_column
}

# Useful surface outputs
output "web_test_name" {
  value = module.ai_webtest_alert.web_test_name
}

output "action_group_id" {
  value = module.ai_webtest_alert.action_group_id
}

output "kql_alert_name" {
  value = module.ai_webtest_alert.kql_alert_name
}
