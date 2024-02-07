output "query_map" {
  value = {
    forecastTables     = "${databricks_sql_query.forecast_tables.id}"
    realtimeTable      = "${databricks_sql_query.realtime_table.id}"
    rtlocation         = "${databricks_sql_query.rtlocation.id}"
    rttemperature      = "${databricks_sql_query.rttemperature.id}"
    rtprecipitation    = "${databricks_sql_query.rtprecipitation.id}"
    rtwind             = "${databricks_sql_query.rtwind.id}"
    rtweatherCondition = "${databricks_sql_query.rtweathercondition.id}"
    hftemperature      = "${databricks_sql_query.hftemperature.id}"
    hfprecipitation    = "${databricks_sql_query.hfprecipitation.id}"
    hfwind             = "${databricks_sql_query.hfwind.id}"
    hfweatherCondition = "${databricks_sql_query.hfweatherCondition.id}"
    dftemperature      = "${databricks_sql_query.dftemperature.id}"
    dfprecipitation    = "${databricks_sql_query.dfprecipitation.id}"
    dfwind             = "${databricks_sql_query.dfwind.id}"
    dfweatherCondition = "${databricks_sql_query.dfweatherCondition.id}"
    dfcelestial        = "${databricks_sql_query.dfcelestial.id}"
  }
}