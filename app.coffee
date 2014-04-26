###
Module dependencies.
###
express   = require("express")
routes    = require("./routes")
register  = require("./routes/register")
http      = require("http")
path      = require("path")
io        = require 'socket.io'
GLOBAL._  = require 'underscore'
GLOBAL._.str = require 'underscore.string'
mongoose  = require 'mongoose'
{Game}    = require './src/game'
{GameData} = require './src/game_data'
{ModelWrapper} = require './model_generator'
app       = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# config に国一覧を
countryModel = require './models/country'
db = countryModel.createConnection 'mongodb://127.0.0.1/countries'
Country = db.model 'Country'
exports.Country = Country

playerModel = require './models/player'
db = playerModel.createConnection 'mongodb://127.0.0.1/players'
Player = db.model 'Player'
exports.Player = Player

app.get "/", routes.index
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

server = http.createServer app

server.listen(app.get('port'))
server_io = io.listen server

server_io.set('close timeout', 60)
server_io.set('heartbeat timeout', 60)

user_id = 0

game = new Game user_id
game.start server_io

# server_io.sockets.on 'connection', (socket)=>
#   socket.on 'msg send', (msg)=>
#     console.info 'msg sended', msg
#     socket.emit "msg:push", msg
#     socket.broadcast.emit "msg:push",( ->
#       console.info 'broadcast push'
#       msg
#     )()
#     # socket.broadcast.emit "turn:draw"

#   socket.on "disconnect", =>
#     console.log('disconnect')
