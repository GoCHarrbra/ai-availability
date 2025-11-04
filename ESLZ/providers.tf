provider "azurerm" {
  features {}
  storage_use_azuread = true
  # No subscription_id here — Terragrunt provides ARM_* env vars.
}
