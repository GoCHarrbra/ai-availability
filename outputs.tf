output "ai_name" {
  value       = azurerm_application_insights.ai.name
  description = "Application Insights resource name."
}

output "web_test_name" {
  value       = azurerm_application_insights_standard_web_test.health.name
  description = "Standard web test name."
}

output "action_group_id" {
  value       = azurerm_monitor_action_group.ag.id
  description = "Action Group resource ID."
}
