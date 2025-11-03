resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ai_availability_failed_locations" {
  name                = "${local.base_name}-health-kql-alert"
  display_name        = "FATAL: unable to reach ${var.app_name}"
  resource_group_name = var.rg_name
  location            = var.location

  scopes                  = [data.azurerm_log_analytics_workspace.law.id]
  description             = "Fatal Error: unable to reach ${var.app_name}. KQL-driven availability alert."
  enabled                 = true
  severity                = var.alert_severity
  evaluation_frequency    = "PT5M"
  window_duration         = "PT5M"
  auto_mitigation_enabled = false

  criteria {
    query                    = var.kql_query
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
    custom_properties = {
      title       = "Fatal Error: unable to reach ${var.app_name}"
      message     = "Availability failure for ${var.app_name} — ${var.backend_health_url}"
      app_name    = var.app_name
      health_url  = var.backend_health_url
      environment = local.env
      region      = var.location
    }
  }

  tags = var.tags

  # Not strictly required, but ensures the web test exists before alert evaluates
  depends_on = [azurerm_application_insights_standard_web_test.health]
}
