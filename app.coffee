###
Module dependencies.
###
express   = require("express")
routes    = require("./routes")
user      = require("./routes/user")
register  = require("./routes/register")
models    = require "./src/models"
http      = require("http")
path      = require("path")
io        = require 'socket.io'
GLOBAL._  = require 'underscore'
GLOBAL._.str = require 'underscore.string'
GLOBAL.Card = require('./src/card').Card
GLOBAL.Conf = require('./config/mysql_config').Conf
mongoose  = require 'mongoose'
GLOBAL.mysql = require 'mysql'
{Game}    = require('./src/game')
{Countries} = require './config/country_seed'
app       = express()

mongoose.connect "mongodb://127.0.0.1/ws-nmg", (error) ->
  console.error 'Youre Shock=>', error if error

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set 'models', models
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use require('stylus').middleware(path.join(__dirname, 'public'))
app.use express.static(path.join(__dirname, "public"))

#settings models
GLOBAL.Player  = app.settings.models.Player
GLOBAL.Country = app.settings.models.Country
GLOBAL.Product = app.settings.models.Product
GLOBAL.Chat    = app.settings.models.Chat

_.map Countries, (sc)->
  country = new Country()
  country.name = sc.name
  country.market_scale = sc.market_scale
  country.max_price = sc.max_price
  country.buying_price = sc.buying_price
  country.save (err)->
    console.info 'err'

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# routes
app.get "/", routes.index
app.get "/users", user.list
app.get "/register", register.register

#registration
app.post '/finish_register', (req, res)->
  player_name = req.body.player_name
  country = req.body.counrty

  player = new Player()
  player.name = player_name
  # player.id = GameData.createGameId()
  # GameData.addId(player.id)
  # GameData.registerPlayer {"#{player.id}": "#{player.name}"}
  player.country = country

  console.log 'player:', player

  player.save (err)->
    console.log 'success for saving user' unless err

  res.redirect '/'

app.post '/sample_register', (req, res)->
  player_name = req.body.player_name
  country = req.body.counrty

  player = new Player()
  player.name = player_name
  # player.id = GameData.createGameId()
  # GameData.addId(player.id)
  # GameData.registerPlayer "#{player.id}": "#{player.name}"
  player.country = country

  player.save (err)->
    console.log 'success for saving user' unless err

server = http.createServer app

server.listen(app.get('port'))
server_io = io.listen server, { log: false }

server_io.set('close timeout', 60)
server_io.set('heartbeat timeout', 60)

game = new Game
game.start server_io

