const parse = require('csv-parse/lib/sync');
const transform = require('stream-transform/lib/sync')
const fs = require('fs');

const AmsterdamFile = fs.readFileSync('./csv/amsterdam.csv');
const NewYorkFile = fs.readFileSync('./csv/new_york.csv');
const BerlinFile = fs.readFileSync('./csv/berlin.csv');


const City = [
  {
    index: 0,
    name: 'Amsterdam', // 0
  },
  {
    index: 1,
    name: 'Berlin', // 1
  },
  {
    index: 2,
    name: 'New York', // 2
  },
];

const Country = [
  {
    index: 0,
    name: 'USA', // 0
  },
  {
    index: 1,
    name: 'Germany', // 1
  },
  {
    index: 2,
    name: 'Netherlands', // 2
  },
];

const Type = parse(NewYorkFile, {
  columns: true,
})
  .reduce(
  (accum, apartment) => accum.indexOf(
    apartment.room_type.toLowerCase()) !== -1
      ? accum
      : [...accum, apartment.neighbourhood_group.toUpperCase()],
    []
  ).map((area, index)=>({index, name: area}))

const getTypeId = (room_type) => Type.find(type => type.type === room_type.toUpperCase()).index;

const getCountryId = (country_name) => Country.find(country => country.name === country_name.toUpperCase()).index;

const getCityId = (city_name) => City.find(city => city.name === city_name.toUpperCase()).index;

const newYork = transform(
  parse(NewYorkFile, {
    columns: true,
  }),
  (record) => ({
      name: record.name,
      neighbourhood: record.neighbourhood_group,
      city_id: getCityId('New York'),
      county_id: getCountryId('USA'),
      host_name: record.host_name,
      description: null,
      type_id: getTypeId(record.room_type),
      minimum_nights: record.minimum_nights,
      price: record.price,
      picture_url: null,
      price: record.price
  })
);

const berlin = transform(
  parse(BerlinFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighborhood,
    city_id: getCityId('Berlin'),
    county_id: getCountryId('Germany'),
    host_name: record.host_name,
    description: null,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price,
    picture_url: null,
  })
);

const amsterdam = transform(
  parse(AmsterdamFile, {
    columns: true,
  }),
  (record) => ({
    name: record.name,
    neighbourhood: record.neighborhood,
    city_id: getCityId('Amsterdam'),
    county_id: getCountryId(record.country),
    host_name: record.host_name,
    description: record.description,
    type_id: getTypeId(record.room_type),
    minimum_nights: record.minimum_nights,
    price: record.price,
    picture_url: record.picture_url,
  })
);

const Property = [...newYork, ...berlin, ...amsterdam];

module.exports = { Property, City, Type, Country };
