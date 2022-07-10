#!/bin/bash

if [[ -z "${SCHEDULER_ENVIRONMENT}" ]]; then
   echo "SCHEDULER_ENVIRONMENT not set, assuming development"
   SCHEDULER_ENVIRONMENT="development"
fi

if [[ ! -d "./${SCHEDULER_ENVIRONMENT}" ]]; then
   echo "${SCHEDULER_ENVIRONMENT} path does not exists! Please make sure the mount is correct."
   exit 1
fi

# Select the crontab file based on the environment
CRON_FILE="${SCHEDULER_ENVIRONMENT}/crontab"
dos2unix "${CRON_FILE}"
echo "Loading crontab file [${CRON_FILE}]"

# Load the crontab file
crontab "${CRON_FILE}"

# Start cron
echo "Starting cron..."
crond -f