// Generated by CoffeeScript 1.6.3
(function() {
  var Country, Game, GameData, ModelWrapper, Player, app, countryModel, db, express, game, http, io, mongoose, path, playerModel, register, routes, server, server_io, user, user_id,
    _this = this;

  express = require("express");

  routes = require("./routes");

  user = require("./routes/user");

  register = require("./routes/register");

  http = require("http");

  path = require("path");

  io = require("socket.io");

  GLOBAL._ = require('underscore');

  GLOBAL._.str = require('underscore.string');

  mongoose = require('mongoose');

  Game = require('./src/game').Game;

  GameData = require('./src/game_data').GameData;

  ModelWrapper = require('./model_generator').ModelWrapper;

  app = express();

  app.set("port", process.env.PORT || 3000);

  app.set("views", path.join(__dirname, "views"));

  app.set("view engine", "jade");

  app.use(express.favicon());

  app.use(express.logger("dev"));

  app.use(express.json());

  app.use(express.urlencoded());

  app.use(express.methodOverride());

  app.use(app.router);

  app.use(express["static"](path.join(__dirname, "public")));

  if ("development" === app.get("env")) {
    app.use(express.errorHandler());
  }

  countryModel = require('./models/country');

  db = countryModel.createConnection('mongodb://127.0.0.1/ws-nmg');

  Country = db.model('Country');

  exports.Country = Country;

  playerModel = require('./models/player');

  db = playerModel.createConnection('mongodb://127.0.0.1/ws-nmg');

  Player = db.model('Player');

  exports.Player = Player;

  app.get("/", function(req, res) {
    return routes.index;
  });

  app.get("/users", user.list);

  app.get("/register", register.register);

  app.post('/finish_register', function(req, res) {
    var country, player, player_name;
    player_name = req.body.player_name;
    country = req.body.counrty;
    player = new Player();
    player.name = player_name;
    player.country = country;
    player.id = GameData.createId();
    player.cache = 30.0;
    player.income = 0.0;
    player.number_of_product = 0;
    player.save(function(err) {
      if (!err) {
        return console.log('success for save user');
      }
    });
    return res.redirect('/');
  });

  server = http.createServer(app);

  server.listen(app.get('port'));

  server_io = io.listen(server);

  server_io.set('close timeout', 60);

  server_io.set('heartbeat timeout', 60);

  user_id = 0;

  game = new Game(user_id);

  game.start(server_io);

}).call(this);
