CREATE TABLE "Type" (
  "type_id" SERIAL PRIMARY KEY,
  "type" varchar UNIQUE NOT NULL
);

CREATE TABLE "City" (
  "city_id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL
);

CREATE TABLE "Country" (
  "country_id" SERIAL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

CREATE TABLE "Property" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "neighbourhood" varchar,
  "city_id" int NOT NULL,
  "country_id" varchar NOT NULL,
  "host_name" varchar NOT NULL,
  "description" varchar,
  "type_id" varchar NOT NULL,
  "minimum_nights" int,
  "price" float NOT NULL,
  "picture_url" varchar
);

ALTER TABLE "Country" ADD FOREIGN KEY ("country_id") REFERENCES "Property" ("country_id");

ALTER TABLE "City" ADD FOREIGN KEY ("city_id") REFERENCES "Property" ("city_id");

ALTER TABLE "Type" ADD FOREIGN KEY ("type_id") REFERENCES "Property" ("type_id");
