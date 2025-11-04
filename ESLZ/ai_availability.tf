terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# You’ll pass this in via -var-file
variable "subscription_id" {
  type = string
}

# One object that carries everything the module needs
variable "ai_webtest_alert" {
  type = any
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Ensure the RG exists for AI/WebTest/AG/Alert
resource "azurerm_resource_group" "monitoring" {
  name     = var.ai_webtest_alert.rg_name
  location = var.ai_webtest_alert.location
  tags     = try(var.ai_webtest_alert.tags, {})
}

module "ai_webtest_alert" {
  # Use your local path or your Git URL
  source = "github.com/0x4849/ai-availability.git?ref=v0.6.0"

  # Placement / naming
  rg_name     = azurerm_resource_group.monitoring.name
  location    = var.ai_webtest_alert.location
  name_prefix = var.ai_webtest_alert.name_prefix
  env         = var.ai_webtest_alert.env
  tags        = try(var.ai_webtest_alert.tags, {})

  # Existing LAW reference
  law_rg_name = var.ai_webtest_alert.law_rg_name
  law_name    = var.ai_webtest_alert.law_name

  # Web test
  web_test_name                  = var.ai_webtest_alert.web_test_name
  backend_health_url             = var.ai_webtest_alert.backend_health_url
  web_test_frequency_seconds     = var.ai_webtest_alert.web_test_frequency_seconds
  web_test_geo_locations         = var.ai_webtest_alert.web_test_geo_locations
  web_test_expected_status       = var.ai_webtest_alert.web_test_expected_status
  web_test_expect_text           = var.ai_webtest_alert.web_test_expect_text
  web_test_pass_if_text_found    = var.ai_webtest_alert.web_test_pass_if_text_found

  # Action group/alerting
  alert_emails                     = var.ai_webtest_alert.alert_emails
  app_name                         = var.ai_webtest_alert.app_name
  alert_severity                   = var.ai_webtest_alert.alert_severity
  alert_failed_locations_threshold = var.ai_webtest_alert.alert_failed_locations_threshold

  # KQL (must contain __WEB_TEST_NAME__ placeholder)
  kql_query          = var.ai_webtest_alert.kql_query
  kql_measure_column = var.ai_webtest_alert.kql_measure_column
}
