resource "azurerm_log_analytics_workspace" "law_app" {
  name                = "${local.base_prefix}-law"  # respects your prefix-resourceName rule
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    local.tags_merged,
    {
      purpose = "app related alerts and insights including app telemtry, app downtime, etc"
    }
  )
}

# Handy outputs for internal wiring (if your module exposes outputs)
output "law_id" {
  value = azurerm_log_analytics_workspace.law_app.id
}

output "law_name" {
  value = azurerm_log_analytics_workspace.law_app.name
}