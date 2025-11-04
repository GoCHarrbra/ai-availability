output "application_insights_name" {
  value       = azurerm_application_insights.ai.name
  description = "Created Application Insights name."
}

output "action_group_name" {
  value       = azurerm_monitor_action_group.ag.name
  description = "Created Action Group name."
}

output "web_test_name" {
  value       = azurerm_application_insights_standard_web_test.health.name
  description = "Created Standard Web Test name."
}

output "alert_name" {
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.ai_availability_failed_locations.name
  description = "Created KQL alert rule name."
}
