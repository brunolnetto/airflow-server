from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator

from datetime import datetime 

with DAG(
    dag_id='python_dag',
    start_date=datetime(2023, 1, 1),  # Set a past start date
    schedule_interval='*/2 * * * *',
    catchup=False,
) as dag:
    start_task = EmptyOperator(
        task_id='start'
    )

    print_hello_world = BashOperator(
        task_id='print_hello_world',
        bash_command='python -c "print(\'Hello World!\')"'
    )

    end_task = EmptyOperator(
        task_id='end'
    )

start_task >> print_hello_world
print_hello_world >> end_task
