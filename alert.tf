# Replace token in the supplied KQL with the ACTUAL web test name
locals {
  final_kql = replace(
    var.kql_query,
    "$${WEB_TEST_NAME}",
    azurerm_application_insights_standard_web_test.health.name
  )
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ai_availability_failed_locations" {
  name                = "${var.name_prefix}-${var.env}-${var.location}-health-kql-alert"
  display_name        = "FATAL: unable to reach ${var.app_name}"
  resource_group_name = var.rg_name
  location            = var.location

  scopes                  = [data.azurerm_log_analytics_workspace.law.id]
  description             = "Fatal Error: unable to reach ${var.app_name} health endpoint. Triggers if >= ${var.alert_failed_locations_threshold} locations fail in the last 5 minutes."
  enabled                 = true
  severity                = var.alert_severity
  evaluation_frequency    = "PT5M"
  window_duration         = "PT5M"
  auto_mitigation_enabled = false

  criteria {
    query                    = local.final_kql
    time_aggregation_method  = "Total"
    operator                 = "GreaterThanOrEqual"
    threshold                = var.alert_failed_locations_threshold

    failing_periods {
      number_of_evaluation_periods             = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag.id]

    # Keep the email clean (EST timestamp computed by AI/KQL, not referenced here)
    custom_properties = {
      title      = "Fatal Error: unable to reach ${var.app_name}"
      message    = "Availability failure for ${var.app_name}"
      app_name   = var.app_name
      health_url = var.backend_health_url
      env        = var.env
      region     = var.location
    }
  }

  tags = var.tags

  depends_on = [azurerm_application_insights_standard_web_test.health]
}
