output "web_test_name" {
  value = azurerm_application_insights_standard_web_test.health.name
}

output "action_group_id" {
  value = azurerm_monitor_action_group.ag.id
}

output "kql_alert_name" {
  value = azurerm_monitor_scheduled_query_rules_alert_v2.ai_availability_failed_locations.name
}
