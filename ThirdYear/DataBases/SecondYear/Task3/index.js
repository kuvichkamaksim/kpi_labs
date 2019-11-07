const parse = require('csv-parse/lib/sync');
const transform = require('stream-transform/lib/sync')
const fs = require('fs');

const CrimesFile = fs.readFileSync('./CrimeSmall.csv');
const AirBnbFile = fs.readFileSync('./AirBnb.csv');
const HealthCenterFile = fs.readFileSync('./HealthCenter.csv');

const airBnbRaw = parse(AirBnbFile, {
  columns: true,
})
const areas = airBnbRaw
  .reduce(
  (accum, apartment) => accum.indexOf(
    apartment.neighbourhood_group.toUpperCase()) !== -1
      ? accum
      : [...accum, apartment.neighbourhood_group.toUpperCase()],
    []
  ).map((area, index)=>({index, area}))

const getAreaId = (area) => areas.find(ar => ar.area === area).index;

const healthCenters = transform(
  parse(HealthCenterFile, {
    columns: true,
  }),
   (record) => ({
    area_id: getAreaId(record['Name of Borough'].toUpperCase()),
    centerName: record['Name of Center'],
    centerAddress: record['Center Address'],
    phoneNumber: record['Telephone Number']
   })
 )

const crimes = transform(
  parse(CrimesFile, {
    columns: true,
  }),
  (record) => ({
    area_id: getAreaId(record.BORO_NM.toUpperCase()),
    description: record.OFNS_DESC,
    date: record.CMPLNT_FR_DT
  })
)

const airBnb = transform(
  airBnbRaw,
  (record) => ({
      area_id: getAreaId(record.neighbourhood_group.toUpperCase()),
      price: record.price,
      name: record.name
  })
  )

console.log(areas[0])
console.log(crimes[0])
console.log(airBnb[0])
console.log(healthCenters[0])
