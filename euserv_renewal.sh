#!/bin/bash
# EUserv Renewal Script

# Replace the following variables with your own values
USERNAME="your_username"
PASSWORD="your_password"
ORDERID="your_order_id"

# Set the renewal period (1, 2 or 3)
RENEWAL_PERIOD="1"

# Get the current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Calculate the expiration date of the order
EXPIRATION_DATE=$(curl -s "https://support.euserv.com/index.iphp?mode=1" -H "Cookie: LOGIN_USERNAME=${USERNAME}; LOGIN_PASSWD=${PASSWORD}" | grep "Order due date" | awk '{print $5}')

# Check if the order has already expired
if [[ ${EXPIRATION_DATE} < ${CURRENT_DATE} ]]; then
    echo "The order has already expired. Please renew manually."
    exit 1
fi

# Calculate the remaining days before expiration
DAYS_LEFT=$(echo $(( ($(date -d "${EXPIRATION_DATE}" +%s) - $(date -d "${CURRENT_DATE}" +%s) )/(60*60*24) )))

# Check if the order has less than the specified number of days left before expiration
if [[ ${DAYS_LEFT} -lt 3 ]]; then
    # Renew the order
    RENEWAL_URL="https://support.euserv.com/index.iphp?mode=1&submode=120&orderid=${ORDERID}&period=${RENEWAL_PERIOD}&price=0.00&passwd=${PASSWORD}"
    RENEWAL_RESULT=$(curl -s "${RENEWAL_URL}" -H "Cookie: LOGIN_USERNAME=${USERNAME}; LOGIN_PASSWD=${PASSWORD}")

    # Check if the renewal was successful
    if [[ ${RENEWAL_RESULT} =~ "Successful" ]]; then
        echo "The order has been renewed for ${RENEWAL_PERIOD} month(s)."
        exit 0
    else
        echo "The order renewal has failed. Please renew manually."
        exit 1
    fi
else
    echo "The order does not need to be renewed at this time."
    exit 0
fi
