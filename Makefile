# Makefile for managing Airflow Docker services

# Variables
DOCKER_COMPOSE_FILE = docker-compose.yml
DOCKER_COMPOSE_CMD = docker-compose -f $(DOCKER_COMPOSE_FILE)
ENV_FILE = .env
FOLDERS = ./dags ./logs ./plugins ./config

# Targets
.PHONY: all build up down restart logs init

all: up

# Create the necessary folders
create-folders:
	mkdir -p $(FOLDERS)

# Initialize the environment file
init-env:
	echo -e "AIRFLOW_UID=$(shell id -u)" > $(ENV_FILE)
	echo -e "POSTGRES_USER=airflow" >> $(ENV_FILE)
	echo -e "POSTGRES_PASSWORD=airflow" >> $(ENV_FILE)
	echo -e "POSTGRES_DB=airflow" >> $(ENV_FILE)
	echo -e "AIRFLOW__CORE__FERNET_KEY=UKMzEm3yIuFYEq1y3-2FxPNWSVwRASpahmQ9kQfEr8E=" >> $(ENV_FILE)
	echo -e "AIRFLOW__CORE__EXECUTOR=CeleryExecutor" >> $(ENV_FILE)
	echo -e "AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True" >> $(ENV_FILE)
	echo -e "AIRFLOW__CORE__LOAD_EXAMPLES=False" >> $(ENV_FILE)
	echo -e "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@postgres/airflow" >> $(ENV_FILE)
	echo -e "AIRFLOW__DATABASE__LOAD_DEFAULT_CONNECTIONS=False" >> $(ENV_FILE)
	echo -e "LIMTER_STORAGE_URI=redis://redis:6379/0" >> $(ENV_FILE)
	echo -e "_AIRFLOW_DB_MIGRATE=True" >> $(ENV_FILE)
	echo -e "_AIRFLOW_WWW_USER_CREATE=True" >> $(ENV_FILE)
	echo -e "_AIRFLOW_WWW_USER_USERNAME=airflow" >> $(ENV_FILE)
	echo -e "_AIRFLOW_WWW_USER_PASSWORD=airflow" >> $(ENV_FILE)

# Initialize the Airflow database
airflow-init:
	docker-compose up -d airflow-init

# Initialize the project
init: create-folders init-env airflow-init

# Build all Docker images
build:
	$(DOCKER_COMPOSE_CMD) build

# Start all services
up: build
	$(DOCKER_COMPOSE_CMD) up airflow-init
	$(DOCKER_COMPOSE_CMD) up -d

# Stop and remove all services
down:
	$(DOCKER_COMPOSE_CMD) down

# Restart all services
restart: down up

# Initialize the Airflow database
init:
	$(DOCKER_COMPOSE_CMD) run --rm airflow-init

# View logs for all services
logs:
	$(DOCKER_COMPOSE_CMD) logs -f

# View logs for a specific service (e.g., airflow-webserver)
logs-%:
	$(DOCKER_COMPOSE_CMD) logs -f $*

# Execute a command inside a running container
exec-%:
	$(DOCKER_COMPOSE_CMD) exec $* /bin/bash

# Run tests or any other commands inside a container
test-%:
	$(DOCKER_COMPOSE_CMD) exec $* pytest

# Clean up Docker volumes and networks
clean:
	docker system prune -f

# Sanitize Docker images: remove dangling and unused images
sanitize:
	docker image prune -a -f
	docker system prune -f
	docker volume prune -f

# List all containers
ps:
	docker ps -a

# Show Docker Compose version
version:
	docker-compose --version
