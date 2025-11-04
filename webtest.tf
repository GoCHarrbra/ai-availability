resource "azurerm_application_insights_standard_web_test" "health" {
  name                    = var.web_test_name
  location                = var.location
  resource_group_name     = var.rg_name
  application_insights_id = azurerm_application_insights.ai.id

  enabled       = true
  frequency     = var.web_test_frequency_seconds   # must be 300/600/900
  timeout       = 30
  retry_enabled = true

  geo_locations = var.web_test_geo_locations

  request {
    url       = var.backend_health_url
    http_verb = "GET"
  }

  validation_rules {
    expected_status_code = var.web_test_expected_status
    content {
      content_match       = var.web_test_expect_text
      ignore_case         = true
      pass_if_text_found  = var.web_test_pass_if_text_found
    }
  }

  tags = var.tags
}
