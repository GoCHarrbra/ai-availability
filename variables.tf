variable "rg_name" {
  type        = string
  description = "Resource group where AI, Web Test, Action Group, and Alert are created."
}

variable "location" {
  type        = string
  description = "Azure region for created resources (e.g., canadacentral)."
}

variable "resource_prefix" {
  type        = string
  description = "Optional enforced prefix for names. If non-empty, names are 'prefix-ai', 'prefix-ag', and 'prefix-health-kql-alert'."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
}

# Existing LAW reference (must already exist)
variable "law_rg_name" {
  type        = string
  description = "Resource group of existing Log Analytics Workspace."
}

variable "law_name" {
  type        = string
  description = "Name of existing Log Analytics Workspace."
}

# Web test config
variable "web_test_name" {
  type        = string
  description = "Exact name for the Standard Web Test (e.g., tfhero-dev-canadacentral-health)."
}

variable "backend_health_url" {
  type        = string
  description = "Public health URL to probe (e.g., https://your-app/health)."
}

variable "web_test_frequency_seconds" {
  type        = number
  description = "Web test frequency in seconds. Valid values: 300, 600, 900."
}

variable "web_test_geo_locations" {
  type        = list(string)
  description = "List of web test location IDs (e.g., us-va-ash-azr)."
}

variable "web_test_expected_status" {
  type        = number
  description = "Expected HTTP status code (e.g., 200)."
}

variable "web_test_expect_text" {
  type        = string
  description = "Text to validate in the response body (e.g., 'healthy')."
}

variable "web_test_pass_if_text_found" {
  type        = bool
  description = "If true, finding the text means PASS; if false, finding the text means FAIL."
}

# Email recipients & alert behavior
variable "alert_emails" {
  type        = list(string)
  description = "List of email recipients for the Action Group."
}

variable "app_name" {
  type        = string
  description = "Friendly app name to show in alert subject/body."
}

variable "alert_severity" {
  type        = number
  description = "Alert severity (0–4). 0 is Sev0."
}

variable "alert_failed_locations_threshold" {
  type        = number
  description = "Trigger threshold: how many locations must fail in 5 minutes (e.g., 2 = 2/3)."
}

# KQL + measure column
variable "kql_query" {
  type        = string
  description = "KQL for the alert. Must include the literal token __WEB_TEST_NAME__ which will be replaced by web_test_name."
}

variable "kql_measure_column" {
  type        = string
  description = "The numeric column name projected by your KQL used for thresholding (e.g., AggregatedValue)."
}
