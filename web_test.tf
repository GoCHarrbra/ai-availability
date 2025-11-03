resource "azurerm_application_insights_standard_web_test" "health" {
  name                    = "${local.base_name}-health"
  location                = var.location
  resource_group_name     = var.rg_name
  application_insights_id = azurerm_application_insights.ai.id

  enabled       = true
  frequency     = var.web_test_frequency_seconds
  timeout       = 30
  retry_enabled = true

  # e.g., ["us-va-ash-azr","us-ca-sjc-azr","emea-gb-db3-azr"]
  geo_locations = var.web_test_geo_locations

  request {
    url       = var.backend_health_url
    http_verb = "GET"
  }

  validation_rules {
    expected_status_code = 200
    content {
      content_match       = "healthy"
      ignore_case         = true
      pass_if_text_found  = true  # ensures "healthy" means PASS
    }
  }

  tags = var.tags
}
