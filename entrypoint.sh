#!/bin/bash
set -e

# Optional: Run any initialization scripts or commands here
# Example: Initialize the database
if [ "$1" = 'webserver' ]; then
    airflow db init
fi

if [ "$1" = 'scheduler' ]; then
    airflow db init
fi

if [ "$1" = 'worker' ]; then
    airflow db init
fi

# Execute the command passed as arguments to this script
exec "$@"
