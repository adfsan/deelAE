CREATE SCHEMA raw;
CREATE USER test_user WITH PASSWORD 'test_password';
GRANT ALL ON DATABASE deel_db TO test_user;
GRANT ALL ON SCHEMA raw TO test_user;
GRANT ALL ON ALL TABLES IN SCHEMA raw TO test_user;