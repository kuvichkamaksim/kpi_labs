const parse = require('csv-parse/lib/sync');
const transform = require('stream-transform/lib/sync')
const fs = require('fs');

const CrimesFile = fs.readFileSync('./csv/CrimeSmall.csv');
const AirBnbFile = fs.readFileSync('./csv/AirBnb.csv');
const HealthCenterFile = fs.readFileSync('./csv/HealthCenter.csv');

const airBnbRaw = parse(AirBnbFile, {
  columns: true,
})
const Borough = airBnbRaw
  .reduce(
  (accum, apartment) => accum.indexOf(
    apartment.neighbourhood_group.toUpperCase()) !== -1
      ? accum
      : [...accum, apartment.neighbourhood_group.toUpperCase()],
    []
  ).map((area, index)=>({index, name: area}))

const getAreaId = (area) => Borough.find(ar => ar.name === area).index;

const HealthCenter = transform(
  parse(HealthCenterFile, {
    columns: true,
  }),
   (record) => ({
    area_id: getAreaId(record['Borough'].toUpperCase()),
    centerName: record['Name of Center'],
    centerAddress: record['Center Address'],
    phoneNumber: record['Telephone Number']
   })
 )

const Crimes = transform(
  parse(CrimesFile, {
    columns: true,
  }),
  (record) => ({
    area_id: getAreaId(record.BORO_NM.toUpperCase()),
    description: record.OFNS_DESC,
    date: (() => {
      const arr = record.CMPLNT_FR_DT.split('/');
      return [arr[2], arr[0], arr[1]].join('-');
    })()
  })
)

const Property = transform(
  airBnbRaw,
  (record) => ({
      area_id: getAreaId(record.neighbourhood_group.toUpperCase()),
      name: record.name,
      price: record.price
  })
  )

// console.log(areas[0])
// console.log(crimes[0])
// console.log(airBnb[0])
// console.log(healthCenters[0])

module.exports = { Borough, Crimes, Property, HealthCenter };
