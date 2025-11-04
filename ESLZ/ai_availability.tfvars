subscription_id = "00000000-0000-0000-0000-000000000000"

rg_name   = "monitoring-dev-rg"
location  = "canadacentral"
name_prefix = "tfhero"
env         = "dev"

tags = {
  env        = "dev"
  created_by = "terraform"
  chapter    = "v30_ai_aca_availability"
}

# Reuse existing LAW
law_rg_name = "tfhero-dev-canadacentral-rg"
law_name    = "tfhero-dev-canadacentral-law"

# Web test
backend_health_url         = "https://your-public-app.example.com/health"
web_test_name              = "tfhero-dev-canadacentral-health"
web_test_frequency_seconds = 300

web_test_geo_locations = [
  "us-va-ash-azr",
  "us-ca-sjc-azr",
  "emea-gb-db3-azr",
]

# Alerting
alert_emails = [
  "first.last@example.com",
  "oncall@example.com",
]

app_name       = "ResumeAI"
alert_severity = 0
alert_failed_locations_threshold = 2

# KQL (must output ONE numeric column named in kql_measure_column)
kql_query = <<KQL

KQL

kql_measure_column = "AggregatedValue"
