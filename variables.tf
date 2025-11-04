variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "law_rg_name" {
  type = string
}

variable "law_name" {
  type = string
}

variable "web_test_name" {
  type = string
}

variable "backend_health_url" {
  type = string
}

variable "web_test_frequency_seconds" {
  type = number
}

variable "web_test_geo_locations" {
  type = list(string)
}

variable "web_test_expected_status" {
  type = number
}

variable "web_test_expect_text" {
  type = string
}

variable "web_test_pass_if_text_found" {
  type = bool
}

variable "alert_emails" {
  type = list(string)
}

variable "app_name" {
  type = string
}

variable "alert_severity" {
  type = number
}

variable "alert_failed_locations_threshold" {
  type = number
}

variable "kql_query" {
  type = string
}

variable "kql_measure_column" {
  type = string
}
