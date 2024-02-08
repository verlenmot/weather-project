terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.34.0"
    }
  }
}

# Dashboard
resource "databricks_sql_dashboard" "dbdashboard" {
  name   = "dashboard-${var.project_name}"
  parent = "folders/${var.directory.object_id}"
}

# Realtime Widgets
resource "databricks_sql_widget" "vizrtlocation" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.rtlocation.id
  position {
    size_x = 2
    size_y = 3
    pos_x  = 0
    pos_y  = 0
  }
}

resource "databricks_sql_widget" "vizrtweathercondition" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.rtweathercondition.id
  position {
    size_x = 2
    size_y = 3
    pos_x  = 0
    pos_y  = 1
  }
}

resource "databricks_sql_widget" "vizrttemperature" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.rttemperature.id
  position {
    size_x = 2
    size_y = 5
    pos_x  = 0
    pos_y  = 2
  }
}

resource "databricks_sql_widget" "vizrtprecipitation" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.rtprecipitation.id
  position {
    size_x = 2
    size_y = 5
    pos_x  = 0
    pos_y  = 3
  }
}

resource "databricks_sql_widget" "vizrtwind" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.rtwind.id
  position {
    size_x = 2
    size_y = 5
    pos_x  = 0
    pos_y  = 4
  }
}

# Hourly Forecast Widgets
resource "databricks_sql_widget" "vizhfweathercondition" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.hfweatherCondition.id
  position {
    size_x = 2
    size_y = 5
    pos_x  = 2
    pos_y  = 0
  }
}
resource "databricks_sql_widget" "vizhftemperature" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.hftemperature.id
  position {
    size_x = 2
    size_y = 8
    pos_x  = 2
    pos_y  = 2
  }
}

resource "databricks_sql_widget" "vizhfprecipitation" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.hfprecipitation.id
  position {
    size_x = 2
    size_y = 6
    pos_x  = 2
    pos_y  = 3
  }
}

resource "databricks_sql_widget" "vizhfwind" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.hfwind.id
  position {
    size_x = 2
    size_y = 8
    pos_x  = 2
    pos_y  = 4
  }
}

# Daily Forecast Widgets
resource "databricks_sql_widget" "vizdfweathercondition" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.dfweatherCondition.id
  position {
    size_x = 2
    size_y = 5
    pos_x  = 4
    pos_y  = 0
  }
}

resource "databricks_sql_widget" "vizdftemperature" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.dftemperature.id
  position {
    size_x = 2
    size_y = 8
    pos_x  = 4
    pos_y  = 2
  }
}

resource "databricks_sql_widget" "vizdfprecipitation" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.dfprecipitation.id
  position {
    size_x = 2
    size_y = 7
    pos_x  = 4
    pos_y  = 3
  }
}

resource "databricks_sql_widget" "vizdfwind" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.dfwind.id
  position {
    size_x = 2
    size_y = 10
    pos_x  = 6
    pos_y  = 4
  }
}

resource "databricks_sql_widget" "vizdfcelestial" {
  dashboard_id     = databricks_sql_dashboard.dbdashboard.id
  visualization_id = databricks_sql_visualization.dfcelestial.id
  position {
    size_x = 2
    size_y = 7
    pos_x  = 6
    pos_y  = 0
  }
}

# Realtime Vizualisations
resource "databricks_sql_visualization" "rtlocation" {
  query_id = var.query_map["rtlocation"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "rttemperature" {
  query_id = var.query_map["rttemperature"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "rtprecipitation" {
  query_id = var.query_map["rtprecipitation"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "rtwind" {
  query_id = var.query_map["rtwind"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "rtweathercondition" {
  query_id = var.query_map["rtweatherCondition"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

# Hourly Forecast Vizualisations
resource "databricks_sql_visualization" "hftemperature" {
  query_id = var.query_map["hftemperature"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "hfprecipitation" {
  query_id = var.query_map["hfprecipitation"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "hfwind" {
  query_id = var.query_map["hfwind"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "hfweatherCondition" {
  query_id = var.query_map["hfweatherCondition"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

# Daily Forecast Visualisations
resource "databricks_sql_visualization" "dftemperature" {
  query_id = var.query_map["dftemperature"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "dfprecipitation" {
  query_id = var.query_map["dfprecipitation"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "dfwind" {
  query_id = var.query_map["dfwind"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "dfweatherCondition" {
  query_id = var.query_map["dfweatherCondition"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

resource "databricks_sql_visualization" "dfcelestial" {
  query_id = var.query_map["dfcelestial"]
  type     = "details"
  name     = ""

  options = jsonencode({})
}

  