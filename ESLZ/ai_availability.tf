# All fields required; must be set in ai-availability.tfvars
variable "ai_webtest_alert" {
  description = "Settings for AI availability, action group, and alerts."
  type = object({
    location                     = string
    resource_prefix              = string
    name_prefix                  = string
    env                          = string
    tags                         = map(string)

    web_test_name                = string
    backend_health_url           = string
    web_test_frequency_seconds   = number
    web_test_geo_locations       = list(string)
    web_test_expected_status     = number
    web_test_expect_text         = string
    web_test_pass_if_text_found  = bool

    alert_emails                 = list(string)
    app_name                     = string
    alert_severity               = number
    alert_failed_locations_threshold = number

    kql_query                    = string
    kql_measure_column           = string
  })
}

module "ai_webtest_alert" {
  source = "github.com/GoCHarrbra/ai-availability.git?ref=v0.9.0"

  # Placement / naming
  rg_name         = module.foundation.rg_name
  location        = var.ai_webtest_alert.location
  resource_prefix = try(var.ai_webtest_alert.resource_prefix, "")
  name_prefix     = var.ai_webtest_alert.name_prefix
  env             = var.ai_webtest_alert.env
  tags            = try(var.ai_webtest_alert.tags, {})

  # Existing LAW (reference only)
  law_rg_name = module.foundation.rg_name
  law_name    = module.foundation.law_name

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
  depends_on = [module.foundation]
}

# Useful outputs for downstream layers
output "application_insights_name" {
  description = "Created Application Insights name."
  value       = module.ai_webtest_alert.application_insights_name
}

output "action_group_name" {
  description = "Created Action Group name."
  value       = module.ai_webtest_alert.action_group_name
}

output "web_test_name" {
  description = "Created Standard Web Test name."
  value       = module.ai_webtest_alert.web_test_name
}

output "alert_name" {
  description = "Created KQL alert rule name."
  value       = module.ai_webtest_alert.alert_name
}
