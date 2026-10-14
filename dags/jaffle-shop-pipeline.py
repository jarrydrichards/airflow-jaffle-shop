import logging
from datetime import datetime, timedelta
from typing import Any

from airflow.decorators import dag
from airflow.operators.bash import BashOperator

DBT_DIR = "/usr/local/airflow/include/dbt"
LOGGER = logging.getLogger(__name__)


def log_task_failure(context: dict[str, Any]) -> None:
    """Log the details needed to investigate a failed dbt task."""
    task_instance = context["ti"]
    dag_run = context["dag_run"]

    LOGGER.error(
        "Jaffle Shop pipeline task failed: dag_id=%s task_id=%s run_id=%s "
        "try_number=%s exception=%s log_url=%s",
        task_instance.dag_id,
        task_instance.task_id,
        dag_run.run_id,
        task_instance.try_number,
        context.get("exception"),
        task_instance.log_url,
    )


DEFAULT_ARGS = {
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
    "on_failure_callback": log_task_failure,
}

@dag(
    dag_id="jaffle_shop_pipeline",
    schedule="@daily",
    start_date=datetime(2026, 5, 22),
    catchup=False,
    default_args=DEFAULT_ARGS,
    tags=["jaffle_shop", "dbt"],
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