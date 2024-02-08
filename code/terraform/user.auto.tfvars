client_id       = ${client_id}
client_secret   = ${client_secret}
tenant_id       = ${tenant_id}
subscription_id = ${subscription_id}
api_key         = ${api_key}
forecast_source = ${path_to_repo} + "/weather-project/code/scala/jars/forecast.jar"
realtime_source = ${path_to_repo} + "/weather-project/code/scala/jars/realtime.jar"
ip_exceptions   = [${user_ip}] # Client IP address
alert_email     = ${user_email}
city            = ${location} # All lower capitals and without spaces
    