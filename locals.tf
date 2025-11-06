locals {
  base_prefix = var.resource_prefix
  kql_final   = replace(var.kql_query, "__WEB_TEST_NAME__", var.web_test_name)
  tags_merged = var.tags
}
