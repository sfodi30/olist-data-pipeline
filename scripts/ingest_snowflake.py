import os

import snowflake.connector
from dotenv import load_dotenv

load_dotenv()

FILES_TO_TABLES = {
    "olist_orders_dataset.csv": "ORDERS",
    "olist_order_items_dataset.csv": "ORDER_ITEMS",
    "olist_order_payments_dataset.csv": "ORDER_PAYMENTS",
    "olist_order_reviews_dataset.csv": "ORDER_REVIEWS",
    "olist_products_dataset.csv": "PRODUCTS",
    "olist_sellers_dataset.csv": "SELLERS",
    "olist_geolocation_dataset.csv": "GEOLOCATION",
    "product_category_name_translation.csv": "PRODUCT_CATEGORY_TRANSLATION",
}

conn = snowflake.connector.connect(
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
)

cursor = conn.cursor()

cursor.execute("""
    SELECT
        CURRENT_USER(),
        CURRENT_WAREHOUSE(),
        CURRENT_DATABASE(),
        CURRENT_SCHEMA()
""")

print(cursor.fetchone())

for file_name, table_name in FILES_TO_TABLES.items():

    print(f"Création de {table_name} à partir de {file_name}...")

    create_query = f"""
    CREATE OR REPLACE TABLE {table_name}
    USING TEMPLATE (
        SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
        FROM TABLE(
            INFER_SCHEMA(
                LOCATION => '@OLIST_STAGE/{file_name}',
                FILE_FORMAT => 'OLIST_CSV_FORMAT'
            )
        )
    );
    """

    cursor.execute(create_query)

    print(f"Table {table_name} créée.")
    copy_query = f"""
    COPY INTO {table_name}
    FROM @OLIST_STAGE/{file_name}
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FORMAT')
    MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
    """

    cursor.execute(copy_query)

    print(f"Données chargées dans {table_name}.")

cursor.close()
conn.close()