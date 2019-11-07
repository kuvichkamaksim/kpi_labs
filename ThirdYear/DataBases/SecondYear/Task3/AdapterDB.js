const { Client } = require('pg');
const dbConfig = require('./config.js');
const knex = require('knex');

class AdapterDB {
  constructor(config) {
    if (!AdapterDB.instance) {
      AdapterDB.instance = this;
      this.connection = this.connect(config);
    }
    return AdapterDB.instance;
  }

  select(table) {
    if (!this.connection) throw new Error('No connection was set!');
    this.connection.select()
      .table(table)
      .then(res => {
        console.log(res)
      })
      .catch(e => console.error(e.stack))
  }

  delete(table, condition) {
    if (!this.connection) throw new Error('No connection was set!');
    this.connection(table)
      .where(condition.column, condition.value)
      .del()
      .then(res => {
        console.log(res)
      })
      .catch(e => console.error(e.stack))
  }

  insert(table, data) {
    if (!this.connection) throw new Error('No connection was set!');
    this.connection(table)
      .insert(data)
      .then(res => {
        console.log(res)
      })
      .catch(e => console.error(e.stack))
  }

  update(table, data, condition) {
    this.connection(table)
      .where(condition.column, condition.sign, condition.value)
      .update(data)
      .then(res => {
        console.log(res)
      })
      .catch(e => console.error(e.stack))
  }

  connect(config) {
    return knex({
      client: 'pg',
      version: '7.2',
      connection: {
        user: config.PGUSER,
        host: config.PGHOST,
        database: config.PGDATABASE,
        password: config.PGPASSWORD,
        port: config.PGPORT,
      }
    });
  }

}

module.exports = { AdapterDB };
