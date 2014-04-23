
###
Module dependencies.
###
express   = require("express")
routes    = require("./routes")
user      = require("./routes/user")
http      = require("http")
path      = require("path")
io        = require 'socket.io'
global._  = require 'underscore'
mongoose  = require 'mongoose'
{Game}    = require './src/game'
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

app.get "/", routes.index
app.get "/users", user.list

# config に国一覧を
countryModel = require './models/country'
db = countryModel.createConnection 'mongodb://127.0.0.1/countries'
Country = db.model 'Country'

userModel = require './models/player'
db = countryModel.createConnection 'mongodb://127.0.0.1/players'
Player = db:model 'Player'

# http.createServer(app).listen app.get("port"), ->
#   console.log "Express server listening on port " + app.get("port")
#   return

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
