subscription_id = "00000000-0000-0000-0000-000000000000"

ai_webtest_alert = {
  # Where to put AI/WebTest/AG/Alert
  rg_name     = "monitoring-dev-rg"
  location    = "canadacentral"
  name_prefix = "tfhero"
  env         = "dev"
  tags = {
    created_by = "terraform"
    chapter    = "v30_ai_aca_availability"
  }

  # Existing LAW (must already exist)
  law_rg_name = "logs-dev-rg"
  law_name    = "logs-dev-law"

  # Web test config
  web_test_name               = "tfhero-dev-canadacentral-health"
  backend_health_url          = "https://YOUR.PUBLIC.URL/health"
  web_test_frequency_seconds  = 300
  web_test_geo_locations      = [
    "us-va-ash-azr",
    "us-ca-sjc-azr",
    "emea-gb-db3-azr"
  ]
  web_test_expected_status    = 200
  web_test_expect_text        = "healthy"
  web_test_pass_if_text_found = true

  # Email recipients
  alert_emails = [
    "first.last@example.com",
    "ops@example.com"
  ]

  # Alert behavior
  app_name                         = "ResumeAI"
  alert_severity                   = 0      # Sev0
  alert_failed_locations_threshold = 2      # 2-of-3

  # KQL (keep the __WEB_TEST_NAME__ token; module will replace it with web_test_name)
  kql_query = <<KQL
AppAvailabilityResults
| where Name == "__WEB_TEST_NAME__"
| where TimeGenerated > ago(5m)
| summarize AggregatedValue = dcountif(Location, Success == false)
| project AggregatedValue
KQL

  # The column your KQL projects (numeric)
  kql_measure_column = "AggregatedValue"
}
