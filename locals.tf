locals {
  # If resource_prefix is provided (non-empty), use it; otherwise derive from name_prefix-env-location.
  derived_prefix = "${var.name_prefix}-${var.env}-${var.location}"

  base_prefix = (trimspace(var.resource_prefix) != "")
    ? var.resource_prefix
    : local.derived_prefix

  # Final KQL: replace token with the actual Standard Web Test name.
  kql_final = replace(var.kql_query, "__WEB_TEST_NAME__", var.web_test_name)

  tags_merged = var.tags
}
