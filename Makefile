# Makefile for managing Airflow Docker services

# Variables
DOCKER_COMPOSE_FILE = docker-compose.yml
DOCKER_COMPOSE_CMD = docker-compose -f $(DOCKER_COMPOSE_FILE)

# Targets
.PHONY: all build up down restart logs init

all: up

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
