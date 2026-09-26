from airflow.sdk import dag
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime


@dag(
    dag_id="olist_pipeline",
    schedule=None,
    start_date=datetime(2026, 9, 1),
    catchup=False,
    tags=["olist"],
)
def olist_pipeline():

    ingest_snowflake = BashOperator(
        task_id="ingest_snowflake",
        bash_command="python /opt/airflow/scripts/ingest_snowflake.py",
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="""
        cd /opt/airflow/olist_dbt &&
        dbt build --profiles-dir /opt/airflow/olist_dbt
        """,
    )

    ingest_snowflake >> dbt_build


olist_pipeline()