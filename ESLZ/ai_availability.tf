# (Assumes versions.tf + providers.tf live in this folder for Terraform/azurerm setup.)

variable "ai_webtest_alert" {
  type        = any
  description = "All settings for AI/WebTest/ActionGroup/Alert."
}

# Ensure (or adopt) the target Resource Group
resource "azurerm_resource_group" "monitoring" {
  name     = var.ai_webtest_alert.rg_name
  location = var.ai_webtest_alert.location
  tags     = try(var.ai_webtest_alert.tags, {})
}

module "ai_webtest_alert" {
  source = "github.com/GoCHarrbra/ai-availability.git?ref=v0.9.0"

  # Placement / naming
  rg_name         = azurerm_resource_group.monitoring.name
  location        = var.ai_webtest_alert.location
  resource_prefix = try(var.ai_webtest_alert.resource_prefix, "")
  name_prefix     = var.ai_webtest_alert.name_prefix
  env             = var.ai_webtest_alert.env
  tags            = try(var.ai_webtest_alert.tags, {})

  # Existing LAW (reference only)
  law_rg_name = var.ai_webtest_alert.law_rg_name
  law_name    = var.ai_webtest_alert.law_name

  # Web test config
  web_test_name               = var.ai_webtest_alert.web_test_name
  backend_health_url          = var.ai_webtest_alert.backend_health_url
  web_test_frequency_seconds  = var.ai_webtest_alert.web_test_frequency_seconds
  web_test_geo_locations      = var.ai_webtest_alert.web_test_geo_locations
  web_test_expected_status    = var.ai_webtest_alert.web_test_expected_status
  web_test_expect_text        = var.ai_webtest_alert.web_test_expect_text
  web_test_pass_if_text_found = var.ai_webtest_alert.web_test_pass_if_text_found

  # Emails & alert behavior
  alert_emails                     = var.ai_webtest_alert.alert_emails
  app_name                         = var.ai_webtest_alert.app_name
  alert_severity                   = var.ai_webtest_alert.alert_severity
  alert_failed_locations_threshold = var.ai_webtest_alert.alert_failed_locations_threshold

  # KQL + measure column
  kql_query          = var.ai_webtest_alert.kql_query
  kql_measure_column = var.ai_webtest_alert.kql_measure_column
}

# Useful outputs for downstream layers
output "monitoring_rg_name" {
  value = azurerm_resource_group.monitoring.name
}

output "web_test_name" {
  value = var.ai_webtest_alert.web_test_name
}
