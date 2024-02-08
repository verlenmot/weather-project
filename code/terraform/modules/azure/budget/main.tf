# Budget
resource "azurerm_consumption_budget_resource_group" "bdg" {
  count             = length(var.amount_array)
  name              = "bdg-${var.amount_array[count.index]}"
  resource_group_id = var.rg_id
  amount            = var.amount_array[count.index]
  time_grain        = "Annually"

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
