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
mongoose  = require 'mongoose'
{Game}    = require('./src/game')
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
app.use express.static(path.join(__dirname, "public"))

#settings models:w
GLOBAL.Player  = app.settings.models.Player
GLOBAL.Country = app.settings.models.Country
GLOBAL.Product = app.settings.models.Product

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# routes
app.get "/", routes.index
app.get "/users", user.list
app.get "/register", register.register

app.post '/finish_register', (req, res)->
  player_name = req.body.player_name
  country = req.body.counrty

  player = new Player()
  player.name = player_name
  player.cache = 30.0
  player.income = 0.0
  player.id = 0
  player.country = country
  player.number_of_product = 0

  console.log 'player:', player

  player.save (err)->
    console.log 'success for saving user' unless err

  res.redirect '/'

app.post '/sample_register', (req, res)->
  player_name = req.body.player_name
  country = req.body.counrty

  player = new Player()

server = http.createServer app

server.listen(app.get('port'))
server_io = io.listen server

server_io.set('close timeout', 60)
server_io.set('heartbeat timeout', 60)

user_id = 0

game = new Game user_id
game.start server_io

