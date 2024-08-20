# Base image
FROM apache/airflow:2.10.0-python3.10

# Switch to root user
USER root

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow

# Add non-root user
RUN useradd -ms /bin/bash airflowuser
USER airflowuser

# Set the working directory
WORKDIR ${AIRFLOW_HOME}

# Copy configuration files
COPY --chown=airflowuser:airflowuser ./dags /opt/airflow/dags
COPY --chown=airflowuser:airflowuser ./logs /opt/airflow/logs
COPY --chown=airflowuser:airflowuser ./plugins /opt/airflow/plugins

# Expose ports
EXPOSE 8080

# Start the webserver with Gunicorn
CMD ["gunicorn", "-w", "4", "-t", "120", "-b", "0.0.0.0:8080", "airflow.www.app:cached_app"]
