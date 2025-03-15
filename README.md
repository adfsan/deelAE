# Instructions

## Postgresql database

Very crude and simple setup just to be able to run dbt and store the provided data.

__Instructions:__

After installing PostgreSQL and ensuring that it is running, create a database by running:
```
psql postgres -f create_db.sql 
```
And a test_user and schemas with:
```
psql deel_db -f scripts/postgresql/create_db_user_schema.sql
```

