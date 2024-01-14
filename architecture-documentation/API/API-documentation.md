# API - Tomorrow.io

Tomorrow.io is an accurate, advanced, and powerful weather intelligence platform.  
The Tomorrow.io API delivers fast & reliable weather data, which is historical, realtime or forecast.  
The location can be localised, using names or using latitude & longitude.
The API responds with JSON format using REST API format.

## Information

Full information on <https://docs.tomorrow.io>.  
Add “Powered by Tomorrow.io” attribution when using icons from documentation.

### Limitations - Free Plan

Requests are limited to 500 per day, 25 per hour and 3 per second.  
There are no maximum weekly or monthly limits.  
The limits are reset at midnight UTC.

Data available for -6H in the past and beyond 4.5 days in the future.  
Forecast calls are restricted to timesteps of 1 hour, for the next 120 hours, our 1 day for the next 5 days.  
Realtime changes every minute.

### Calls

For the data endpoints, one API call gets all time steps of a data type (realtime/forecast/historical) for a specific time period for one location.  
The realtime and forecast weather APIs will be used in this application.

Non precipitation forecast variables: once per hour.  
Non precipitation current conditions: every 5 minutes (to once per hour for more meaningful information).  
Short term precipitation calling: every 15 minutes to once per hour.  
Forecasts are run every 10 minutes on average.

Time is represented in ISO 8601 format.  
The timestamps are in UTC.  

### Interesting Data Fields

* Temperature (Celsius)
* TemperatureApparent (Celsius)
* Humidity (%)
* WindSpeed (m/s)
* precipitationIntensity (mm/hr)
* precipitationProbability (%)
* precipitationType  (integer)
* rainAccumulation (mm)
* snowAccumulation (mm)
* sunriseTime & sunsetTime (UTC ISO-8601)
* visibility (km)
* cloudCover (%)
* moonPhase (double)
* uvIndex & uvHealthConcern (integer & string)
* weatherCodeDay / weatherCodeNight / weatherCodeFullDay / weatherCode (integer)
