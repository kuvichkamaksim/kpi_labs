const AdapterDB = require('./AdapterDB');
const dbConfig = require('./config.js');
const parser = require('./parser');

const db = new AdapterDB(dbConfig);

for (let table in parser) {
  if (table !== "Property") {
    for (let row of parser[table]) {
      const {index, ...tuple} = row;
      const obj = {id: index, ...tuple };
      db.insert(table, obj);
    }
  } else {
    for (let row of parser[table]) {
      db.insert(table, row);
    }
  }
}

db.disconnect();
