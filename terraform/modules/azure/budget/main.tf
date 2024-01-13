resource "azurerm_consumption_budget_resource_group" "bdg" {
  name              = "bdg-${var.amount}"
  resource_group_id = var.rg_id

  amount = var.amount
  time_grain = "Monthly"

  time_period {
    start_date = "2024-01-01T00:00:00Z"
  }

  notification {
    enabled        = true
    operator       = "EqualTo"
    threshold_type = "Actual"
    threshold      = 50.0
    contact_emails = [var.alert_email]
  }

    notification {
    enabled        = true
    operator       = "EqualTo"
    threshold_type = "Actual"
    threshold      = 75.0
    contact_emails = [var.alert_email]
  }

      notification {
    enabled        = true
    operator       = "EqualTo"
    threshold_type = "Actual"
    threshold      = 100.0
    contact_emails = [var.alert_email]
  }

}
