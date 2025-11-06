# All fields required; must be set in ai-availability.tfvars
variable "ai_availability" {
  description = "Settings for AI availability, action group, and alerts."
  type = object({
    resource_prefix              = string

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

module "ai_availability" {
  source = "github.com/GoCHarrbra/ai-availability.git?ref=v1.0.0"
  depends_on = [module.foundation]

  # Placement / naming
  rg_name         = module.foundation.rg_name
  location        = module.foundation.location
  resource_prefix = try(var.ai_availability.resource_prefix, "")
  tags            = module.foundation.tags

  # Existing LAW (reference only)
  law_rg_name = module.foundation.rg_name
  law_name    = module.foundation.law_name

  # Web test config
  web_test_name               = var.ai_availability.web_test_name
  backend_health_url          = var.ai_availability.backend_health_url
  web_test_frequency_seconds  = var.ai_availability.web_test_frequency_seconds
  web_test_geo_locations      = var.ai_availability.web_test_geo_locations
  web_test_expected_status    = var.ai_availability.web_test_expected_status
  web_test_expect_text        = var.ai_availability.web_test_expect_text
  web_test_pass_if_text_found = var.ai_availability.web_test_pass_if_text_found

  # Emails & alert behavior
  alert_emails                     = var.ai_availability.alert_emails
  app_name                         = var.ai_availability.app_name
  alert_severity                   = var.ai_availability.alert_severity
  alert_failed_locations_threshold = var.ai_availability.alert_failed_locations_threshold

  # KQL + measure column
  kql_query          = var.ai_availability.kql_query
  kql_measure_column = var.ai_availability.kql_measure_column
}

# Useful outputs for downstream layers
output "application_insights_name" {
  description = "Created Application Insights name."
  value       = module.ai_availability.application_insights_name
}

output "action_group_name" {
  description = "Created Action Group name."
  value       = module.ai_availability.action_group_name
}

output "web_test_name" {
  description = "Created Standard Web Test name."
  value       = module.ai_availability.web_test_name
}

output "alert_name" {
  description = "Created KQL alert rule name."
  value       = module.ai_availability.alert_name
}
