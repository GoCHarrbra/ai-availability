resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ai_availability_failed_locations" {
  name                = "${var.name_prefix}-${var.env}-${var.location}-health-kql-alert"
  display_name        = "FATAL: unable to reach ${var.app_name}"
  resource_group_name = var.rg_name
  location            = var.location

  scopes                  = [data.azurerm_log_analytics_workspace.law.id]
  description             = "Fatal Error: unable to reach ${var.app_name} health endpoint. Triggers when failed locations >= ${var.alert_failed_locations_threshold} in the last 5 minutes."
  enabled                 = true
  severity                = var.alert_severity
  evaluation_frequency    = "PT5M"
  window_duration         = "PT5M"
  auto_mitigation_enabled = false

  criteria {
    # Your tfvars KQL MUST return a single numeric column named var.kql_measure_column
    query = var.kql_query

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

    # Common Alert Schema custom props (show in emails/ITSM)
    custom_properties = {
      title       = "Fatal Error: unable to reach ${var.app_name}"
      message     = "Availability failure for ${var.app_name}."
      app_name    = var.app_name
      environment = var.env
      region      = var.location
      web_test    = var.web_test_name
      health_url  = var.backend_health_url
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_application_insights_standard_web_test.health
  ]
}
