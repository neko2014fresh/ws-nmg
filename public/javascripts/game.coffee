$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  $('#start').on 'click', ->
    socket.emit('turn:start')

  $('#draw_card').on 'click', ->
    message = $("#message")
    alert message
    socket.emit('turn:draw')

  $('#start').on 'click', ->
    socket.emit('turn:start')

  socket.on "turn:start", (msg)=>


  socket.on "msg:push", (msg)=>
    alert "msg"
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)