How To Reproduce / Use This Project

Step 1: Load /data/*.csv into your Snowflake instance under RAW_DATA schema.
Step 2: Run /snowflake/create_tables.sql (creates the tables).
Step 3: Run /snowflake/create_views.sql (creates the analytics views).
Step 4: Run any /snowflake/analysis_queries.sql for custom queries.
Step 5: Open Tableau Desktop or Public, connect to Snowflake, and load the provided .twbx/dashboard file for full interactivity.

All SQL is modular and can be reused for any similar road safety dataset.

