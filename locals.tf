# Decide base prefix for AI/AG/Alert:
# - If resource_prefix provided (non-empty), use it.
# - Else derive from name_prefix-env-location to keep your older naming working.
locals {
  derived_prefix = "${var.name_prefix}-${var.env}-${var.location}"

  base_prefix = length(trimspace(var.resource_prefix)) > 0
    ? var.resource_prefix
    : local.derived_prefix

  # Final KQL (replace token with the explicit Standard Web Test name the caller passed)
  kql_final = replace(var.kql_query, "__WEB_TEST_NAME__", var.web_test_name)

  tags_merged = var.tags
}
