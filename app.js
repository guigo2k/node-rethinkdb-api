var async      = require('async');
var express    = require('express');
var bodyParser = require('body-parser');
var r          = require('rethinkdb');

var config     = require(__dirname + '/modules/config.js');
var user       = require(__dirname + '/modules/user.js');
var app        = express();

app.use(bodyParser.json());

// Users
app.route('/user')
  .get(user.getAll)
  .post(user.createUser);

// Single user
app.route('/user/:id')
  .get(user.getUser)
  .delete(user.deleteUser);

// If we reach this middleware the route could not be handled and must be unknown.
app.use(handle404);

// Generic error handling middleware.
app.use(handleError);

/*
 * Page-not-found middleware.
 */
function handle404(req, res, next) {
  res.status(404).end('not found');
}

/*
 * Generic error handling middleware.
 * Send back a 500 page and log the error to the console.
 */
function handleError(err, req, res, next) {
  console.error(err.stack);
  res.status(500).json({err: err.message});
}

/*
 * Store the db connection and start listening on a port.
 */
function startExpress(connection) {
  app._rdbConn = connection;
  app.listen(config.express.port);
  console.log('Listening on port ' + config.express.port);
}

/*
 * Connect to rethinkdb, create needed tables/indexes and start express.
 */
async.waterfall([
  function connect(callback) {
    r.connect(config.rethinkdb, callback);
  },
  function createDatabase(connection, callback) {
    // Create the database if needed.
    r.dbList().contains(config.rethinkdb.db).do(function(containsDb) {
      return r.branch(
        containsDb,
        {created: 0},
        r.dbCreate(config.rethinkdb.db)
      );
    }).run(connection, function(err) {
      callback(err, connection);
    });
  },
  function createTable(connection, callback) {
    // Create the table if needed.
    r.tableList().contains('user').do(function(containsTable) {
      return r.branch(
        containsTable,
        {created: 0},
        r.tableCreate('user')
      );
    }).run(connection, function(err) {
      callback(err, connection);
    });
  },
  function createIndex(connection, callback) {
    // Create the index if needed.
    r.table('user').indexList().contains('name').do(function(hasIndex) {
      return r.branch(
        hasIndex,
        {created: 0},
        r.table('user').indexCreate('name')
      );
    }).run(connection, function(err) {
      callback(err, connection);
    });
  },
  function waitForIndex(connection, callback) {
    // Wait for the index to be ready.
    r.table('user').indexWait('name').run(connection, function(err, result) {
      callback(err, connection);
    });
  }
], function(err, connection) {
  if(err) {
    console.error(err);
    process.exit(1);
    return;
  }

  startExpress(connection);
});
