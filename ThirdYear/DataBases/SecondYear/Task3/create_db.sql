DROP DATABASE IF EXISTS task3;
CREATE DATABASE task3;

CREATE USER task3 WITH password 'task3';
GRANT ALL PRIVILEGES ON DATABASE task3 TO task3;

\c task3;

CREATE TABLE "Borough" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

CREATE TABLE "Property" (
  "id" SERIAL PRIMARY KEY,
  "area_id" int NOT NULL,
  "name" varchar,
  "price" int
);

CREATE TABLE "Crimes" (
  "id" SERIAL PRIMARY KEY,
  "area_id" int NOT NULL,
  "description" varchar,
  "date" date NOT NULL
);

CREATE TABLE "HealthCenter" (
  "id" SERIAL PRIMARY KEY,
  "area_id" int NOT NULL,
  "centerName" varchar NOT NULL,
  "centerAddress" varchar NOT NULL,
  "phoneNumber" varchar NOT NULL
);

ALTER TABLE "Borough" OWNER TO task3;
ALTER TABLE "Property" OWNER TO task3;
ALTER TABLE "Crimes" OWNER TO task3;
ALTER TABLE "HealthCenter" OWNER TO task3;

ALTER TABLE "Property" ADD FOREIGN KEY ("area_id") REFERENCES "Borough" ("id");

ALTER TABLE "Crimes" ADD FOREIGN KEY ("area_id") REFERENCES "Borough" ("id");

ALTER TABLE "HealthCenter" ADD FOREIGN KEY ("area_id") REFERENCES "Borough" ("id");
