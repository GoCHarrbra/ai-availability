# Replace token in the KQL with the actual web test name
locals {
  kql_final = replace(var.kql_query, "__WEB_TEST_NAME__", var.web_test_name)
}
