# API GET REQUESTS

## Forecast Request

### Forecast GET

<https://api.tomorrow.io/v4/weather/forecast?location={{location}}&apikey={{api_key}}&units={{units}}&timesteps={{timesteps}}>

With:

{{baseUrl}}: <https://api.tomorrow.io/v4>  

{{location}}: City name ('amsterdam') or Latitude & longitude ('52.371807, 4.896029')  

{{api_key}}: personal API key  

{{units}}: Metric ('metric')  

{{timesteps}}:  Interval between items ("1h", "1d")  

### Forecast JSON

Metrics:  

1d:  
6 days  
14,69 KB  
606 lines

1h:  
120 hours
76,62 KB
4054 lines  

Combined:  
6 days, 120 hours  
90,6 KB  
4650 lines

Example:  
{
    "timelines": {
        "hourly": [{120 hours}]
        "daily": [
            {
                "time": "2024-01-14T05:00:00Z",
                "values": {
                    "cloudBaseAvg": 0.52,
                    "cloudBaseMax": 0.88,
                    "cloudBaseMin": 0.07,
                    "cloudCeilingAvg": 0.65,
                    "cloudCeilingMax": 4.04,
                    "cloudCeilingMin": 0,
                    "cloudCoverAvg": 68.51,
                    "cloudCoverMax": 100,
                    "cloudCoverMin": 21.09,
                    "dewPointAvg": 0.62,
                    "dewPointMax": 3,
                    "dewPointMin": -1.57,
                    "evapotranspirationAvg": 0.018,
                    "evapotranspirationMax": 0.033,
                    "evapotranspirationMin": 0,
                    "evapotranspirationSum": 0.417,
                    "freezingRainIntensityAvg": 0,
                    "freezingRainIntensityMax": 0,
                    "freezingRainIntensityMin": 0,
                    "humidityAvg": 85.13,
                    "humidityMax": 96,
                    "humidityMin": 77.67,
                    "iceAccumulationAvg": 0,
                    "iceAccumulationLweAvg": 0,
                    "iceAccumulationLweMax": 0,
                    "iceAccumulationLweMin": 0,
                    "iceAccumulationLweSum": 0,
                    "iceAccumulationMax": 0,
                    "iceAccumulationMin": 0,
                    "iceAccumulationSum": 0,
                    "moonriseTime": "2024-01-14T09:45:45Z",
                    "moonsetTime": "2024-01-14T19:49:41Z",
                    "precipitationProbabilityAvg": 9.7,
                    "precipitationProbabilityMax": 24,
                    "precipitationProbabilityMin": 0,
                    "pressureSurfaceLevelAvg": 1005.88,
                    "pressureSurfaceLevelMax": 1011.57,
                    "pressureSurfaceLevelMin": 1001.12,
                    "rainAccumulationAvg": 0.1,
                    "rainAccumulationLweAvg": 0.05,
                    "rainAccumulationLweMax": 0.46,
                    "rainAccumulationLweMin": 0,
                    "rainAccumulationMax": 0.44,
                    "rainAccumulationMin": 0,
                    "rainAccumulationSum": 2.25,
                    "rainIntensityAvg": 0.07,
                    "rainIntensityMax": 0.39,
                    "rainIntensityMin": 0,
                    "sleetAccumulationAvg": 0,
                    "sleetAccumulationLweAvg": 0,
                    "sleetAccumulationLweMax": 0,
                    "sleetAccumulationLweMin": 0,
                    "sleetAccumulationLweSum": 0,
                    "sleetAccumulationMax": 0,
                    "sleetAccumulationMin": 0,
                    "sleetIntensityAvg": 0,
                    "sleetIntensityMax": 0,
                    "sleetIntensityMin": 0,
                    "snowAccumulationAvg": 0.22,
                    "snowAccumulationLweAvg": 0,
                    "snowAccumulationLweMax": 0,
                    "snowAccumulationLweMin": 0,
                    "snowAccumulationLweSum": 0,
                    "snowAccumulationMax": 2.29,
                    "snowAccumulationMin": 0,
                    "snowAccumulationSum": 4.97,
                    "snowIntensityAvg": 0,
                    "snowIntensityMax": 0,
                    "snowIntensityMin": 0,
                    "sunriseTime": "2024-01-14T07:28:00Z",
                    "sunsetTime": "2024-01-14T16:10:00Z",
                    "temperatureApparentAvg": -0.96,
                    "temperatureApparentMax": 4.77,
                    "temperatureApparentMin": -3.14,
                    "temperatureAvg": 2.9,
                    "temperatureMax": 4.77,
                    "temperatureMin": 1.53,
                    "uvHealthConcernAvg": 0,
                    "uvHealthConcernMax": 0,
                    "uvHealthConcernMin": 0,
                    "uvIndexAvg": 0,
                    "uvIndexMax": 0,
                    "uvIndexMin": 0,
                    "visibilityAvg": 13.9,
                    "visibilityMax": 16,
                    "visibilityMin": 6.24,
                    "weatherCodeMax": 1101,
                    "weatherCodeMin": 1101,
                    "windDirectionAvg": 282.73,
                    "windGustAvg": 7.48,
                    "windGustMax": 9.68,
                    "windGustMin": 4.5,
                    "windSpeedAvg": 4.72,
                    "windSpeedMax": 5.81,
                    "windSpeedMin": 2.8
                }
            ,
            { ... until 2024-01-19}
            }
        ]
    },
    "location": {
        "lat": 52.37308120727539,
        "lon": 4.892453193664551,
        "name": "Amsterdam, Noord-Holland, Nederland",
        "type": "administrative"
    }
}
  
## Realtime

### Realtime GET

<https://api.tomorrow.io/v4/weather/realtime?location={{location}}&apikey={{api_key}}&units={{units}}>

With:  

{{baseUrl}}: <https://api.tomorrow.io/v4>  

{{location}}: City name ('amsterdam') or Latitude & longitude ('52.371807, 4.896029')  

{{api_key}}: personal API key  

{{units}}: Metric ('metric')  

### Realtime JSON

Metrics:  
1,15 KB  
33 lines  

Example:  

{
    "data": {
        "time": "2024-01-14T11:14:00Z",
        "values": {
            "cloudBase": 0.09,
            "cloudCeiling": 0.09,
            "cloudCover": 59,
            "dewPoint": 3,
            "freezingRainIntensity": 0,
            "humidity": 95,
            "precipitationProbability": 0,
            "pressureSurfaceLevel": 1009.07,
            "rainIntensity": 0,
            "sleetIntensity": 0,
            "snowIntensity": 0,
            "temperature": 3.81,
            "temperatureApparent": 0.46,
            "uvHealthConcern": 0,
            "uvIndex": 0,
            "visibility": 10.74,
            "weatherCode": 1101,
            "windDirection": 207.81,
            "windGust": 6.69,
            "windSpeed": 3.88
        }
    },
    "location": {
        "lat": 52.37308120727539,
        "lon": 4.892453193664551,
        "name": "Amsterdam, Noord-Holland, Nederland",
        "type": "administrative"
    }
}
