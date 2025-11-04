resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ai_availability_failed_locations" {
  name                = "${local.base_name}-health-kql-alert"
  display_name        = "FATAL: unable to reach ${var.app_name}"
  resource_group_name = var.rg_name
  location            = var.location

  scopes                  = [data.azurerm_log_analytics_workspace.law.id]
  description             = "Fatal Error: unable to reach ${var.app_name} health endpoint. Triggers if >= ${var.alert_failed_locations_threshold} locations fail in 5 minutes."
  enabled                 = true
  severity                = var.alert_severity                 # 0 = Sev0
  evaluation_frequency    = "PT5M"
  window_duration         = "PT5M"
  auto_mitigation_enabled = false

  criteria {
    query = local.kql_final

    # Must be numeric and match your KQL's projected column name
    metric_measure_column   = var.kql_measure_column
    time_aggregation_method = "Total"
    operator                = "GreaterThanOrEqual"
    threshold               = var.alert_failed_locations_threshold

    failing_periods {
      number_of_evaluation_periods             = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag.id]

    # Shown in Common Alert Schema payload; email subject/body are mainly driven by Azure,
    # but display_name & description above make them a lot nicer.
    custom_properties = {
      title      = "FATAL: unable to reach ${var.app_name}"
      message    = "Unable to reach the backend of ${var.app_name} (health URL: ${var.backend_health_url})"
      app_name   = var.app_name
      health_url = var.backend_health_url
      env        = var.env
      region     = var.location
      # NOTE: Email timestamps shown by Azure are UTC; for Eastern-only formatting you’d need a Logic App.
    }
  }

  tags = var.tags

  depends_on = [azurerm_application_insights_standard_web_test.health]
}
