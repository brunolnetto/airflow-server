#!/bin/bash
set -e

airflow db migrate

# Execute the command passed as arguments to this script
exec "$@"
