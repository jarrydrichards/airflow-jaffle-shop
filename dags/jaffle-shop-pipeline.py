from airflow.decorators import dag
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_DIR = "/usr/local/airflow/include/dbt"

@dag(
    dag_id="jaffle_shop_pipeline",
    schedule="@daily",
    start_date=datetime(2026, 5, 22),
    catchup=False,
    tags=["jaffle_shop", "dbt"]
)
def jaffle_shop_pipeline():
    dbt_seed = BashOperator(
        task_id="dbt_seed",
        bash_command=f"cd {DBT_DIR} && dbt seed --profiles-dir ."
    )

    dbt_run_staging = BashOperator(
        task_id="dbt_run_staging",
        bash_command=f"cd {DBT_DIR} && dbt build -s staging.* --exclude tag:marts --profiles-dir ."
    )

    dbt_run_intermediate = BashOperator(
        task_id="dbt_run_intermediate",
        bash_command=f"cd {DBT_DIR} && dbt build -s intermediate.* --exclude tag:marts --profiles-dir ."
    )

    dbt_run_marts = BashOperator(
        task_id="dbt_run_marts",
        bash_command=f"cd {DBT_DIR} && dbt build -s marts.* --profiles-dir ."
    )

    # Set dependencies
    dbt_seed >> dbt_run_staging >> dbt_run_intermediate >> dbt_run_marts

# run the pipeline
jaffle_shop_pipeline()