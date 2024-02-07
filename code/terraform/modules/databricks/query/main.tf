terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.34.0"
    }
  }
}

# Tables
resource "databricks_sql_query" "realtime_table" {
  data_source_id = var.warehouse_id
  name           = "Realtime table"
  query          = <<-EOT
                        CREATE TABLE IF NOT EXISTS realtime (
                        id BIGINT GENERATED ALWAYS AS IDENTITY,
                        timestamp TIMESTAMP NOT NULL,
                        name STRING NOT NULL,
                        temperature DOUBLE,
                        temperatureApparent DOUBLE,
                        humidity INT,
                        cloudCover INT,
                        precipitationProbability INT,
                        rainIntensity DOUBLE,
                        snowIntensity DOUBLE,
                        visibility DOUBLE,
                        windSpeed DOUBLE,
                        windGust DOUBLE,
                        uvIndex INT,
                        uvHealthConcern INT,
                        weatherCode INT,
                        weatherCondition STRING) 
                        USING DELTA;
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "forecast_tables" {
  data_source_id = var.warehouse_id
  name           = "Forecast tables"
  query          = <<-EOT
                        CREATE TABLE IF NOT EXISTS hourly_forecast (
                        id BIGINT GENERATED ALWAYS AS IDENTITY,
                        timestamp TIMESTAMP NOT NULL,
                        time TIMESTAMP NOT NULL,
                        date STRING NOT NULL,
                        hour INT NOT NULL,
                        name STRING NOT NULL,
                        temperature DOUBLE,
                        temperatureApparent DOUBLE,
                        humidity DOUBLE,
                        cloudCover DOUBLE,
                        precipitationProbability DOUBLE,
                        rainAccumulation DOUBLE,
                        rainIntensity DOUBLE,
                        SnowAccumulation DOUBLE,
                        snowIntensity DOUBLE,
                        visibility DOUBLE,
                        windSpeed DOUBLE,
                        windGust DOUBLE,
                        uvIndex DOUBLE,
                        uvHealthConcern DOUBLE,
                        weatherCode INT,
                        weatherCondition STRING) 
                        USING DELTA;

                        CREATE TABLE IF NOT EXISTS daily_forecast (
                        id BIGINT GENERATED ALWAYS AS IDENTITY,
                        timestamp TIMESTAMP NOT NULL,
                        date STRING NOT NULL,
                        name STRING NOT NULL,
                        temperatureMin DOUBLE,
                        temperatureMax DOUBLE,
                        temperatureApparentMin DOUBLE,
                        temperatureApparentMax DOUBLE,
                        humidityMin DOUBLE,
                        humidityMax DOUBLE,
                        cloudCoverMin DOUBLE,
                        cloudCoverMax DOUBLE,
                        precipitationProbabilityMin DOUBLE,
                        precipitationProbabilityMax DOUBLE,
                        rainAcumulationMin DOUBLE,
                        rainAcumulationMax DOUBLE,
                        rainIntensityMin DOUBLE,
                        rainIntensityMax DOUBLE,
                        snowAccumulationMin DOUBLE,
                        snowAccumulationMax DOUBLE,
                        snowIntensityMin DOUBLE,
                        snowIntensityMax DOUBLE,
                        visibilityMin DOUBLE,
                        visibilityMax DOUBLE,
                        windSpeedMin DOUBLE,
                        windSpeedMax DOUBLE,
                        windGustMin DOUBLE,
                        windGustMax DOUBLE,
                        uvIndexMin DOUBLE,
                        uvIndexMax DOUBLE,
                        uvHealthConcernMin DOUBLE,
                        uvHealthConcernMax DOUBLE,
                        weatherCodeMin INT,
                        weatherCodeMax INT,
                        moonriseTime TIMESTAMP,
                        moonsetTime TIMESTAMP,
                        sunriseTime TIMESTAMP,
                        sunsetTime TIMESTAMP,
                        weatherConditionMin STRING,
                        weatherConditionMax STRING) 
                        USING DELTA;
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

# Realtime queries
resource "databricks_sql_query" "rtlocation" {
  data_source_id = var.warehouse_id
  name           = "Location"
  query          = <<-EOT
                        SELECT name AS Location FROM realtime
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM realtime);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "rttemperature" {
  data_source_id = var.warehouse_id
  name           = "Realtime Temperature"
  query          = <<-EOT
                        SELECT CONCAT(temperature, "°C") AS Temperature , CONCAT(temperatureApparent, "°C") As ApparentTemperature ,
                         CONCAT(humidity, "%") AS Humidity, uvIndex AS UVindex FROM realtime
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM realtime);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "rtprecipitation" {
  data_source_id = var.warehouse_id
  name           = "Realtime Precipitation"
  query          = <<-EOT
                        SELECT CONCAT(precipitationProbability, "%") AS PrecipitationProbability, 
                        CONCAT(rainIntensity, " mm/hr") AS RainIntensity,
                        CONCAT(snowIntensity, " mm/hr") AS SnowIntensity FROM realtime
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM realtime);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "rtwind" {
  data_source_id = var.warehouse_id
  name           = "Realtime Air"
  query          = <<-EOT
                        SELECT CONCAT(windSpeed, " m/s") AS WindSpeed, CONCAT(windGust, " m/s") AS WindGust,
                        CONCAT(cloudcover, "%") AS CloudCover, CONCAT(visibility, " km") AS Visibility FROM realtime
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM realtime);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}


resource "databricks_sql_query" "rtweathercondition" {
  data_source_id = var.warehouse_id
  name           = "Realtime Conditions"
  query          = <<-EOT
                        SELECT  weatherCondition AS WeatherCondition FROM realtime
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM realtime);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

# Hourly Forecast Queries
resource "databricks_sql_query" "hftemperature" {
  data_source_id = var.warehouse_id
  name           = "Hourly Temperature Forecast"
  query          = <<-EOT
                        SELECT date AS Date, hour AS Hour, CONCAT(temperature, "°C") AS Temperature, CONCAT(temperatureApparent, "°C") As ApparentTemperature,
                         CONCAT(humidity, "%") AS Humidity, UVindex FROM hourly_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM hourly_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "hfprecipitation" {
  data_source_id = var.warehouse_id
  name           = "Hourly Rain Forecast"
  query          = <<-EOT
                        SELECT date AS Date, hour AS Hour, CONCAT(precipitationProbability, "%") AS PrecipitationProbability,
                        CONCAT(rainIntensity, " mm/hr") AS RainIntensity FROM hourly_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM hourly_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "hfwind" {
  data_source_id = var.warehouse_id
  name           = "Hourly Air Forecast"
  query          = <<-EOT
                        SELECT date AS Date, hour AS Hour, CONCAT(windSpeed, " m/s") AS WindSpeed, CONCAT(windGust, " m/s") AS WindGust,
                        CONCAT(cloudcover, "%") AS CloudCover, CONCAT(visibility, " km") AS Visibility FROM hourly_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM hourly_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}


resource "databricks_sql_query" "hfweatherCondition" {
  data_source_id = var.warehouse_id
  name           = "Hourly Conditions Forecast"
  query          = <<-EOT
                        SELECT date AS Date, hour AS Hour, weatherCondition AS WeatherCondition FROM hourly_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM hourly_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

# Daily Forecast Queries
resource "databricks_sql_query" "dftemperature" {
  data_source_id = var.warehouse_id
  name           = "Daily Temperature Forecast"
  query          = <<-EOT
                        SELECT date AS Date, CONCAT(temperatureMax, "°C") AS MaxTemperature,
                        CONCAT(temperatureMin, "°C") AS MinTemperature,
                        CONCAT(humidityMax, "%") AS MaxHumidity,
                        CONCAT(humidityMin, "%") AS MinHumidity,
                        UVindexMax As MaxUvindex,
                        UVindexMin AS MinUVindex
                          FROM daily_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM daily_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "dfprecipitation" {
  data_source_id = var.warehouse_id
  name           = "Daily Rain Forecast"
  query          = <<-EOT
                        SELECT date AS Date, CONCAT(precipitationProbabilityMax, "%") AS MaxPrecipitationProbability,
                         CONCAT(precipitationProbabilityMin, "%") AS MinPrecipitationProbability,
                         CONCAT(rainIntensityMax, " mm/hr") AS MaxRainIntensity,
                         CONCAT(rainIntensityMin, " mm/hr") AS MinRainIntensity FROM daily_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM daily_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "dfwind" {
  data_source_id = var.warehouse_id
  name           = "Daily Air Forecast"
  query          = <<-EOT
                        SELECT date AS Date, CONCAT(windSpeedMax, " m/s") AS MaxWindSpeed,
                         CONCAT(windSpeedMin, " m/s") AS MinWindSpeed,
                        CONCAT(windGustMax, " m/s") AS MaxWindGust,
                        CONCAT(windGustMin, " m/s") AS MinWindGust,
                        CONCAT(cloudcoverMax, "%") AS MaxCloudCover,
                        CONCAT(cloudcoverMin, "%") AS MinCloudCover,
                        CONCAT(visibilityMax, " km") AS MaxVisibility,
                        CONCAT(visibilityMin, " km") AS MinVisibility FROM daily_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM daily_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}


resource "databricks_sql_query" "dfweatherCondition" {
  data_source_id = var.warehouse_id
  name           = "Daily Conditions Forecast"
  query          = <<-EOT
                        SELECT date AS date, weatherConditionMax AS BestWeatherCondition,
                         weatherConditionMin AS WorstWeatherCondition FROM daily_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM daily_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}

resource "databricks_sql_query" "dfcelestial" {
  data_source_id = var.warehouse_id
  name           = "Daily Celestial Forecast"
  query          = <<-EOT
                        SELECT date AS Date,
                        CONCAT(extract(HOUR FROM sunriseTime), ":",extract(MINUTE FROM sunriseTime)) AS Sunrise,
                        CONCAT(extract(HOUR FROM sunsetTime), ":",extract(MINUTE FROM sunsetTime)) AS Sunset,             
                        CONCAT(extract(HOUR FROM moonriseTime), ":",extract(MINUTE FROM moonriseTime)) AS Moonrise,
                        CONCAT(extract(HOUR FROM moonsetTime), ":",extract(MINUTE FROM moonsetTime)) AS Moonset       
                         FROM daily_forecast
                        WHERE `timestamp` = (SELECT max(`timestamp`) FROM daily_forecast);
                    EOT
  parent         = "folders/${var.workspace_folder}"
}