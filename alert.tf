resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ai_availability_failed_locations" {
  name                = "${local.base_prefix}-health-kql-alert"
  display_name        = "FATAL: unable to reach ${var.app_name}"
  resource_group_name = var.rg_name
  location            = var.location

  scopes                  = [azurerm_log_analytics_workspace.law_app.id]
  description             = "Fatal Error: unable to reach ${var.app_name} health endpoint. Triggers if >= ${var.alert_failed_locations_threshold} locations fail in 5 minutes."
  enabled                 = true
  severity                = var.alert_severity
  evaluation_frequency    = "PT5M"
  window_duration         = "PT5M"
  auto_mitigation_enabled = false

  criteria {
    query                    = local.kql_final
    time_aggregation_method  = "Total"
    operator                 = "GreaterThanOrEqual"
    threshold                = var.alert_failed_locations_threshold
    metric_measure_column    = var.kql_measure_column

    failing_periods {
      number_of_evaluation_periods             = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag.id]

    custom_properties = {
      title       = "Fatal Error: unable to reach ${var.app_name}"
      message     = "Availability failure — ${var.app_name} — ${var.backend_health_url}"
      app_name    = var.app_name
      health_url  = var.backend_health_url
      region      = var.location
    }
  }

  tags = local.tags_merged

  depends_on = [
    azurerm_application_insights_standard_web_test.health
  ]
}
