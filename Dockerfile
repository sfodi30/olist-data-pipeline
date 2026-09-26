FROM apache/airflow:3.3.1-python3.12

USER airflow

RUN pip install --no-cache-dir \
    dbt-snowflake==1.12.0 \
    snowflake-connector-python==4.7.2 \
    python-dotenv