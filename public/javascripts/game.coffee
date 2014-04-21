$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  $('#btn').on 'click', ->
    message = $("#message")
    console.log message
    socket.emit "msg send", message.val()

  socket.on "msg:push", (msg)=>
    alert(msg)
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)