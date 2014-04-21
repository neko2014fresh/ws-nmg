
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
_    = require "underscore"
socket_io = require 'socket.io'
app = express()

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

# http.createServer(app).listen app.get("port"), ->
#   console.log "Express server listening on port " + app.get("port")
#   return

server = http.createServer app

io = socket_io.listen server
server.listen(app.get('port'))

io.set('close timeout', 60)
io.set('heartbeat timeout', 60)

io.sockets.on 'connection', (socket)=>
  socket.on 'msg send', (msg)=>
    console.info 'msg sended', msg

    socket.emit "msg:push", msg

    socket.broadcast.emit "msg:push",( ->
      console.info 'broadcast push'
      msg
    )()

  socket.on "disconnect", =>
    console.log('disconnect')
