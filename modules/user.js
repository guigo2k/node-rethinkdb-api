
var r = require('rethinkdb');

/*
 * Get all users.
 */
module.exports.getAll = function(req, res, next) {
  r.table('user').run(req.app._rdbConn, function(err, cursor) {
    if(err) {
      return next(err);
    }

    // Retrieve all users in an array.
    cursor.toArray(function(err, result) {
      if(err) {
        return next(err);
      }

      res.json({ users: result });
    });
  });
}

/*
 * Create a new user.
 */
module.exports.createUser = function(req, res, next) {
  var user = req.body;
  console.dir(user);

  r.table('user').insert(user, {returnChanges: true}).run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result.changes[0].new_val);
  });
}
