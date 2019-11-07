drop database if exists task2;
create database task2;

--create user task1 with password task3
create user task3 with password 'task3';

-- add grants
grant connect on database task2 to task3;
