module.exports = {
  rethinkdb: {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    db: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    authKey: process.env.TOKEN_SECRET
  },
  express: {
     port: process.env.HTTP_PORT
  }
};
