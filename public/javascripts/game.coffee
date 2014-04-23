

$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  $('#select-country-btn').on 'click', ->
    country = $('#select-country').val()
    socket.emit('turn:country', {'country': country})

  $('#start').on 'click', ->
    socket.emit('turn:start')  

  $('#draw_card').on 'click', ->
    console.info "draw card"
    socket.emit('turn:draw')

  $('#sample').on 'click', ->
    socket.emit('turn:sample')

  $('#action-btn').on 'click', ->
    action_type = $('#action-type').val()
    socket.emit 'turn:action', {'actionType': action_type}

  socket.on 'turn:country_selected', (dayta)->
    alert('#{data.user_id}が#{data.country}')

  socket.on 'turn:start_msg', (data)->
    alert(data.msg)

  socket.on 'turn:draw_end', (data)->
    console.info "draw_end"
    alert(data.cardType)

  socket.on 'turn:action_selected', (data)->
    alert(data.actionType)

  socket.on "sample", (msg)=>
    alert(msg)

  socket.on "msg:push", (msg)=>
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)