#!/bin/bash

# Get location data using IP Geolocation

# Recommended with API, but you can try w/o API [IPINFO.IO]
# API_TOKEN="YOUR_API_TOKEN"
# location_data=$(curl -s "https://ipinfo.io?token=$API_TOKEN" 2>/dev/null)
# location_data=$(curl -s https://ipinfo.io 2>/dev/null) #[Limited requests. Require API to send 50k request/month]

# Extract city and country code (ISO 3166-1 alpha-2 code)
# CITY=$(echo "$location_data" | jq -r '.city // empty')
# COUNTRY=$(echo "$location_data" | jq -r '.country // empty')

# IPINFO Alternative [IP-API.COM]
# location_data=$(curl -s "http://ip-api.com/json/" 2>/dev/null)

# Extract city and country code
# CITY=$(echo "$location_data" | jq -r '.city // empty')
# COUNTRY=$(echo "$location_data" | jq -r '.countryCode // empty')
# Visit http://ip-api.com/json/ to find other variables

# HARDCODE Location
CITY="Indore"

if [[ -n "$CITY" ]]; then
    weather_info=$(curl -s "wttr.in/$CITY?format=%c+%C+%t" 2>/dev/null)

    if [[ -n "$weather_info" ]]; then
        # Split data
        IFS=' ' read -r icon condition_and_temp <<< "$weather_info"
        rest="${weather_info#"$icon "}"
        temperature="${rest##* }"
        condition="${rest% $temperature}"

        # Replace icon with thermometer symbol (󰖕) to match original style
        thermometer_icon="󰖕"

        # Format temperature (ensure space between number and °C if needed)
        temperature_formatted=$(echo "$temperature" | sed 's/°C/ °C/')

        echo -e "{\"text\":\"$thermometer_icon $temperature_formatted\", \"alt\":\"$CITY\", \"tooltip\":\"$CITY: $temperature_formatted $condition\"}"
    else
        echo "Weather info unavailable for $CITY"
    fi
else
    echo "Unable to determine your location"
fi
