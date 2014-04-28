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
    player_name = if $('#player-name').val() is "" then "小保方晴子" else $('#player-name').val()
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

  $('#turn_end').on 'click', ->
    socket.emit 'turn:finish'

  $('#chat-button').on 'click', ->
    chat = $("#chat-msg").val()
    socket.emit 'chat:on', "msg": chat

  socket.on 'turn:country_selected', (data)->
    alert("#{data.user_id}が#{data.country}を選びました。")

  socket.on 'turn:setting_msg', (data)->
    alert("#{data.player}の初期設定が終わりました。")

  socket.on "turn:start_msg", (data)->
    alert("#{data.name}のターンです。")

  socket.on 'turn:draw_end', (data)->
    console.info "draw_end"
    alert("#{data.player}が#{cardType}を引きました。#{data.player}は行動を選択して下さい")

  socket.on 'turn:action_selected', (data)=>
    actionType = data.action
    targetCountry = $('#target-country').val()
    amount = $('#amount').val()
    socket.emit "turn:#{actionType}", 'country': targetCountry, 'amount': amount

  socket.on 'all_country', (data)=>
    if $('#countries').children().length == 0
      _.map data.countries, (country)=>
        html = "
          <br>
          <div id='#{country.name}' class='countries'>
            <div class='country-name'>
              国名:...#{country.name}
            </div>
            <div class='market-scale'>
              市場規模:...#{country.market_scale}
            </div>
            <div class='market-rest'>
              市場猶予:...#{country.market_rest}
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
          <br>
          "
        $('#countries').append(html)

  socket.on 'update_country_owner_name', (data) =>
    country = data.country
    player_name = data.name
    $('#' + "#{country} .owner").html("本社...#{player_name}")

  socket.on 'initial_player_status', (data)=>
    html = "
      <div class='name'>
        名前:#{data.name}
      </div>
      <div class='country'>
        国:#{data.country}
      </div>
      <div class='cache'>
        キャッシュ:#{data.cache}
      </div>
      <div class='income'>
        純利益:#{data.income}
      </div>
      <div class='number-of-product'>
        製品数:#{data.product}
      </div>
    "
    $('#player-status').append(html)

  socket.on "warn:not_your_turn", (msg)=>
    alert('おめえのターンじゃねぇから！')

  socket.on "chat:send", (data)=>
    html = "
      <div class='msg-sender'>
        #{data.msg}
      </div>
    "
    $("#chat-area").append(html)

  socket.on "warn:already_init", (msg)=>
    alert('もう登録しとるやろ！')

  socket.on "warn:already_draw", (msg)=>
    alert('もう引いとるやろ！')

  socket.on "turn:finished", (data)=>
    alert("ターン終了。次は#{data.player_name}のターンです")

  socket.on "msg:push", (msg)=>
    date = new Date()
    console.info('push')

  socket.on "msg updateDB", =>
    console.info 'msg'
)