locals {
  env       = lookup(var.tags, "env", "dev")
  base_name = "${var.name_prefix}-${local.env}-${var.location}"
}
