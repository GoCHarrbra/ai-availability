resource "azurerm_monitor_action_group" "ag" {
  name                = "${local.base_prefix}-ag"
  resource_group_name = var.rg_name
  short_name          = "alerts"
  tags                = local.tags_merged

  dynamic "email_receiver" {
    for_each = toset(var.alert_emails)
    content {
      name                    = "email-${replace(email_receiver.value, "@", "_at_")}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}
