

$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  setTimeout ->
    console.info 'check update'
  , 1000

  socket.emit('get_all_country')

  $('#register-country-btn').on 'click', ->
    player_name = $('#player-name').val()
    register_country = $('#register-country').val()
    socket.emit "save_player_and_country", 'player_name': player_name, 'country': register_country

  $('#init-start').on 'click', ->
    socket.emit('turn:init_start')

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

  socket.on 'turn:country_selected', (data)->
    alert("#{data.user_id}が#{data.country}を選びました")

  socket.on 'turn:start_msg', (data)->
    alert("#{current_turn_owner}のターンです")

  socket.on 'turn:draw_end', (data)->
    console.info "draw_end"
    alert(data.cardType)

  socket.on 'turn:action_selected', (data)->
    alert(data.actionType)

  socket.on 'all_country', (data)=>
    _.map data.countries, (country)->
      html = "
        <div id='#{country.name}' class='countries'>
          <div class='country-name'>
            国名:...#{country.name}
          </div>
          <div class='market-scale'>
            市場規模:...#{country.market_scale}
          </div>
          <div class='max-price'>
            最高値:...#{country.max_price}
          </div>
          <div class='buying_price'>
            仕入れ値:...#{country.buying_price}
          </div>
          <div class='owner'>
            本社...#{country.player_name}
          </div>
        </div>
        "
      $('#countries').append(html)

  socket.on 'update_country', (data) =>
    country = data.country
    player_name = data.name
    $('#' + "#{country} .owner").html("本社...#{player_name}")

  socket.on "sample", (msg)=>
    alert(msg)

  socket.on "msg:push", (msg)=>
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)