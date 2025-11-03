resource "azurerm_monitor_action_group" "ag" {
  name                = "${local.base_name}-ag"
  resource_group_name = var.rg_name
  short_name          = "alerts"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = toset(var.alert_emails)
    content {
      name                    = "email-${replace(email_receiver.value, "@", "_at_")}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}
