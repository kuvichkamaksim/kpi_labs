const AdapterDB = require('./AdapterDB');
const dbConfig = require('./config.js');
const parser = require('./parser');

const db = new AdapterDB(dbConfig);

for (let table in parser) {
  if (table === "Borough") {
    for (let row of parser[table]) {
      const obj = {id: row.index, name: row.name };
      db.insert(table, obj);
    }
  } else {
    for (let row of parser[table]) {
      db.insert(table, row);
    }
  }
}

db.disconnect();
