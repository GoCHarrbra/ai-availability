module "ai_availability" {
  source = "github.com/your-org/ai-availability-module//?ref=v1.0.0"

  subscription_id                 = var.subscription_id
  rg_name                         = var.rg_name
  location                        = var.location
  name_prefix                     = var.name_prefix
  law_rg_name                     = var.law_rg_name
  law_name                        = var.law_name
  backend_health_url              = var.backend_health_url
  alert_emails                    = var.alert_emails
  app_name                        = var.app_name
  alert_severity                  = var.alert_severity
  web_test_frequency_seconds      = var.web_test_frequency_seconds
  web_test_geo_locations          = var.web_test_geo_locations
  alert_failed_locations_threshold= var.alert_failed_locations_threshold
  kql_query                       = var.kql_query
  tags                            = var.tags
}
