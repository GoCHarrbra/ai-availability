locals {
  base_name = "${var.name_prefix}-${var.env}-${var.location}"
}

resource "azurerm_application_insights" "ai" {
  name                        = "${local.base_name}-ai"
  location                    = var.location
  resource_group_name         = var.rg_name
  application_type            = "web"
  workspace_id                = data.azurerm_log_analytics_workspace.law.id
  internet_ingestion_enabled  = true
  internet_query_enabled      = true
  tags                        = var.tags
}
