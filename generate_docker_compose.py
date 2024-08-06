from jinja2 import Template
from cryptography.fernet import Fernet

# Load the template file
with open('docker-compose.j2.yml', 'r') as file:
    template_str = file.read()

# Create a Jinja2 Template object
template = Template(template_str)

fernet_key=Fernet.generate_key().decode()

# Define the context with variables including the number of workers
context = {
    'postgres_version': '13',
    'redis_version': '6',
    'airflow_version': '2.6.0',
    'postgres_user': 'airflow',
    'postgres_password': 'airflow',
    'postgres_db': 'airflow',
    'fernet_key': fernet_key,
    'executor': 'CeleryExecutor',
    'load_examples': 'false',
    'dags_are_paused': 'true',
    'num_workers': 5
}

# Render the template with the context
rendered_yaml = template.render(context)

# Save the rendered output to a file
with open('docker-compose.yml', 'w') as f:
    f.write(rendered_yaml)

print("Docker Compose file generated successfully.")
