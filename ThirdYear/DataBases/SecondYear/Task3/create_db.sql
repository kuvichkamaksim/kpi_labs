DROP DATABASE IF EXISTS task3;
CREATE DATABASE task3;

\c task3;

CREATE TABLE "Type" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "City" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "Country" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "Continent" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "Property" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR NOT NULL,
  "neighbourhood" VARCHAR,
  "city_id" INT NOT NULL REFERENCES "City"(id),
  "country_id" INT NOT NULL REFERENCES "Country"(id),
  "continent_id" INT NOT NULL REFERENCES "Continent"(id),
  "host_name" VARCHAR NOT NULL,
  "description" VARCHAR,
  "type_id" INT NOT NULL REFERENCES "Type"(id),
  "minimum_nights" INT,
  "price" FLOAT NOT NULL,
  "picture_url" VARCHAR,
  "availability_365" INT,
  "reviews_per_month" FLOAT,
  "creation_date" DATE DEFAULT CURRENT_DATE
);
