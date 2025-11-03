subscription_id = "00000000-0000-0000-0000-000000000000"

rg_name   = "monitoring-dev-rg"
location  = "canadacentral"
name_prefix = "tfhero"

law_rg_name = "logs-dev-rg"
law_name    = "logs-dev-law"

backend_health_url = "https://my-public-app.example.com/health"

alert_emails = [
  "first.last@example.com",
  "sre@example.com",
]

app_name      = "ResumeAI"
alert_severity = 0   # Sev0

web_test_frequency_seconds = 300
web_test_geo_locations = [
  "us-va-ash-azr",
  "us-ca-sjc-azr",
  "emea-gb-db3-azr",
]

# Fire when >= 2 locations fail in the window
alert_failed_locations_threshold = 2

# KQL — must be supplied here
kql_query = 

tags = {
  env        = "dev"
  owner      = "platform"
  created_by = "terraform"
  chapter    = "v30_ai_aca_availability"
}
