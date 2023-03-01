#!/bin/bash

# Script to add a new cron job for euserv_renewal.sh
# Usage: bash add_cron_job.sh <cron_schedule>

if [ -z "$1" ]; then
  echo "Please provide cron schedule as argument (e.g. '0 5 * * *' for 5am every day)"
  exit 1
fi

# Add new cron job
(crontab -l ; echo "$1 /bin/bash /root/euserv_renewal.sh ") | crontab -

echo "New cron job added:"
crontab -l
