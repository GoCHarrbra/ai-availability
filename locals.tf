locals {
  derived_prefix = "${var.name_prefix}-${var.env}-${var.location}"
  base_prefix    = trimspace(var.resource_prefix) != "" ? var.resource_prefix : local.derived_prefix
  kql_final      = replace(var.kql_query, "__WEB_TEST_NAME__", var.web_test_name)
  tags_merged    = var.tags
}
