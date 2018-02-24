module.exports = {
  rethinkdb: {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    db: process.env.DB_NAME,
    authKey: process.env.TOKEN_SECRET
  },
  express: {
     port: process.env.SERVER_PORT
  }
};
