CREATE SCHEMA raw;
CREATE USER test_user WITH PASSWORD 'test_password';
grant all
on database deel_db
to test_user
;
grant all
on schema raw
to test_user
;
grant all
on all tables in schema raw
to test_user
;
