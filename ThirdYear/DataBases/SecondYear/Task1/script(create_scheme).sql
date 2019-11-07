-- $ sudo -u postgres psql
CREATE DATABASE stationery;
CREATE USER user1 WITH PASSWORD '1212';
GRANT ALL PRIVILEGES ON DATABASE stationery TO user1;
-- $ sudo psql -U task1 -d sale
