
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

/*
 * Get a specific user.
 */
module.exports.getUser = function(req, res, next) {
  var id = req.params.id;

  r.table('user').get(id).run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result);
  });
}

/*
 * Delete a specific user.
 */
module.exports.deleteUser = function(req, res, next) {
  var id = req.params.id;

  r.table('user').get(id).delete().run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json({success: true});
  });
}

/*
 * Get user state.
 */
module.exports.getUserState = function(req, res, next) {
  var id = req.params.id;

  r.table('user').get(id).pluck('gamesPlayed', 'score').run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result);
  });
}

/*
 * Save user state.
 */
module.exports.saveUserState = function(req, res, next) {
  var state = req.body;
  var id    = req.params.id;

  r.table('user').get(id).update(state, {returnChanges: true}).run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result);
  });
}

/*
 * Get user friends.
 */
module.exports.getUserFriends = function(req, res, next) {
  var id = req.params.id;

  r.table('user').get(id).pluck('friends').run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result);
  });
}

/*
 * Save user friends.
 */
module.exports.saveUserFriends = function(req, res, next) {
  var friends = req.body;
  var id    = req.params.id;

  r.table('user').get(id).update(friends, {returnChanges: true}).run(req.app._rdbConn, function(err, result) {
    if(err) {
      return next(err);
    }

    res.json(result);
  });
}
