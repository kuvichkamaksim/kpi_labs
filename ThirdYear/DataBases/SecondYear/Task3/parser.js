const parse = require('csv-parse/lib/sync');
const transform = require('stream-transform/lib/sync')
const fs = require('fs');

const AmsterdamFile = fs.readFileSync('./csv/amsterdam.csv');
const NewYorkFile = fs.readFileSync('./csv/new_york.csv');
const BerlinFile = fs.readFileSync('./csv/berlin.csv');
const BostonFile = fs.readFileSync('./csv/boston.csv');
const LAFile = fs.readFileSync('./csv/los_angeles.csv');
const StokholmFile = fs.readFileSync('./csv/stokholm.csv');

const City = [
  {
    index: 0,
    name: 'Amsterdam',
  },
  {
    index: 1,
    name: 'Berlin',
  },
  {
    index: 2,
    name: 'New York',
  },
  {
    index: 3,
    name: 'Boston',
  },
  {
    index: 4,
    name: 'Los Angeles',
  },
  {
    index: 5,
    name: 'Stokholm',
  },
];

const Country = [
  {
    index: 0,
    name: 'USA',
  },
  {
    index: 1,
    name: 'Germany',
  },
  {
    index: 2,
    name: 'Netherlands',
  },
  {
    index: 3,
    name: 'Sweden',
  },
];

const Continent = [
  {
    index: 0,
    name: 'Europe',
  },
  {
    index: 1,
    name: 'North America',
  },
];

const TypeArr = parse(StokholmFile, {
  columns: true,
})
  .reduce(
  (accum, apartment) => accum.indexOf(
    apartment.room_type.toLowerCase()) !== -1
      ? accum
      : [...accum, apartment.room_type.toUpperCase()],
    []
  );

const Type = Array.from(new Set(TypeArr)).map((area, index)=>({index, name: area}));

const getTypeId = (room_type) => Type.find(type => type.name.toUpperCase() === room_type.toUpperCase()).index;

const getCountryId = (country_name) => Country.find(country => country.name.toUpperCase() === country_name.toUpperCase()).index;

const getCityId = (city_name) => City.find(city => city.name.toUpperCase() === city_name.toUpperCase()).index;

const getContinentId = (continent_name) => Continent.find(continent => continent.name.toUpperCase() === continent_name.toUpperCase()).index;

const priceToFloat = (price) => {
  let validPrice = price[0] === "$" ? price.substr(1) : price;
  validPrice = validPrice.replace(',', '');
  return validPrice;
};

const newYork = transform(
  parse(NewYorkFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood_group,
    city_id: getCityId('New York'),
    country_id: getCountryId('USA'),
    continent_id: getContinentId('North America'),
    host_name: record.host_name,
    description: null,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price,
    picture_url: null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const berlin = transform(
  parse(BerlinFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood,
    city_id: getCityId('Berlin'),
    country_id: getCountryId('Germany'),
    continent_id: getContinentId('Europe'),
    host_name: record.host_name,
    description: null,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price,
    picture_url: null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const amsterdam = transform(
  parse(AmsterdamFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood,
    city_id: getCityId('Amsterdam'),
    country_id: getCountryId("Netherlands"),
    continent_id: getContinentId('Europe'),
    host_name: record.host_name,
    description: record.description,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price,
    picture_url: record.picture_url !== '' ? record.picture_url : null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const boston = transform(
  parse(BostonFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood,
    city_id: getCityId('Boston'),
    country_id: getCountryId("USA"),
    continent_id: getContinentId('North America'),
    host_name: record.host_name,
    description: record.description,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: priceToFloat(record.price),
    picture_url: record.picture_url !== '' ? record.picture_url : null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const los_angeles = transform(
  parse(LAFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood,
    city_id: getCityId('Los Angeles'),
    country_id: getCountryId("USA"),
    continent_id: getContinentId('North America'),
    host_name: record.host_name,
    description: record.description,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: priceToFloat(record.price),
    picture_url: record.picture_url !== '' ? record.picture_url : null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const stokholm = transform(
  parse(StokholmFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighbourhood,
    city_id: getCityId('Stokholm'),
    country_id: getCountryId("Sweden"),
    continent_id: getContinentId('Europe'),
    host_name: record.host_name,
    description: record.description,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price !== '' ? record.price * 0.11 : null,
    picture_url: record.picture_url !== '' ? record.picture_url : null,
    availability_365: record.availability_365,
    reviews_per_month: record.reviews_per_month !== '' ? record.reviews_per_month : null,
    creation_date: record.last_review !== '' ? record.last_review : null,
  })
);

const Property = [...newYork, ...berlin, ...amsterdam, ...boston, ...los_angeles, ...stokholm];

module.exports = { City, Type, Country, Continent, Property };
