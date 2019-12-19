CREATE TABLE "Type" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

CREATE TABLE "City" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

CREATE TABLE "Country" (
  "id" INT NOT NULL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

CREATE TABLE "Property" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "neighbourhood" varchar,
  "city_id" int NOT NULL REFERENCES "City"(id),
  "country_id" INT NOT NULL REFERENCES "Country"(id),
  "host_name" varchar NOT NULL,
  "description" varchar,
  "type_id" INT NOT NULL REFERENCES "Type"(id),
  "minimum_nights" int,
  "price" float NOT NULL,
  "picture_url" varchar
);
