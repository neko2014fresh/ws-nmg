$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  $('#start').on 'click', ->
    socket.emit('turn:start')  

  $('#draw_card').on 'click', ->
    message = $("#message")
    socket.emit('turn:draw')

  $('#sample').on 'click', ->
    console.log('clicked!!')
    socket.emit('turn:sample')

  socket.on 'turn:start_msg', (msg)->
    alert(msg)

  socket.on "sample", (msg)=>
    alert(msg)

  socket.on "msg:push", (msg)=>
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)