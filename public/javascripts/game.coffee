$(->
  console.log 'loaded'

  socket = io.connect()
  socket.on "connect", =>
    console.log "connected"

  setTimeout ->
    console.info 'check update'
  , 1000

  socket.emit 'get_all_country'
  socket.emit 'get_all_chat'
  socket.emit 'get_current_turn_owner'

  $('#register-country-btn').on 'click', ->
    player_name = if $('#player-name-form').val() is "" then "小保方晴子" else $('#player-name-form').val()
    register_country = $('#register-country').val()
    socket.emit "save_player_and_country", 'player_name': player_name, 'country': register_country

  $('#init-start').on 'click', ->
    socket.emit 'get_current_turn_owner'
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
    $("#chat-msg").val ""
    socket.emit 'chat:on', "msg": chat

  $('#game-end').on 'click', ->
    socket.emit 'game:end' 

  socket.on 'turn:country_selected', (data)->
    alert("#{data.user_id}が#{data.country}を選びました。")

  socket.on 'turn:setting_msg', (data)->
    alert("#{data.player}の初期設定が終わりました。")

  socket.on "turn:start_msg", (data)->
    alert("#{data.name}のターンです。")

  socket.on 'turn:draw_end', (data)->
    console.info "draw_end"
    alert("#{data.player}が#{data.cardType}を引きました。#{data.player}は行動を選択して下さい")

  socket.on 'turn:action_selected', (data)=>
    actionType = data.action
    targetCountry = $('#target-country').val()
    amount = $('#amount').val()
    socket.emit "turn:#{actionType}", 'country': targetCountry, 'amount': amount

  socket.on "turn:action_buy_end", (data)=>
    country = data.country_name
    # $("#" + "#{counrty}")

  socket.on 'all_country', (data)=>
    if $('#countries tbody').children().length == 0
      _.map data.countries, (country)=>
        # Market Data
        html = "
          <tr id='#{country.name}'>
            <td class='country-name'> #{country.name} </td>
            <td class='market-scale'> #{country.market_scale} </td>
            <td class='market-rest'> #{country.market_rest} </td>
            <td class='max-price'> #{country.max_price} </td>
            <td class='buying_price'> #{country.buying_price} </td>
            <td class='owner'> #{country.player_name} </td>
          </tr>
        "
        $('#countries tbody').append(html)

  socket.on 'all_chat', (data)=>
    if $('#chat-area').children().length == 0
      _.map data.chats, (chat)=>
        html = "
        <div class='chat-container'>
          <div class='sender'>
            #{chat.sender} :
          </div>
          <div class='message'>
            #{chat.message}
          </div>
        </div>
        "
        $('#chat-area').append html

  socket.on 'update_country_owner_name', (data) =>
    country = data.country
    player_name = data.name
    $('#' + "#{country} .owner").html("#{player_name}")

  socket.on 'current_turn_owner', (data)->
    $('#game-status #turn-owner .value').html(data.turn_owner_name)

  socket.on 'initial_player_status', (data)=>
    $('#game-status #player-name .value').html(data.name)
    $('#game-status #cash .value').html(data.cash)
    $('#game-status #stock .value').html(data.product)
    # html = "
    #   <div class='name'>
    #     名前:#{data.name}
    #   </div>
    #   <div class='country'>
    #     国:#{data.country}
    #   </div>
    #   <div class='cash'>
    #     キャッシュ:#{data.cash}
    #   </div>
    #   <div class='income'>
    #     純利益:#{data.income}
    #   </div>
    #   <div class='number-of-product'>
    #     製品数:#{data.product}
    #   </div>
    # "
    # $('#player-status').append(html)

  socket.on "warn:not_your_turn", (msg)=>
    alert('おめえのターンじゃねぇから！')

  socket.on "chat:send", (data)=>
    html = "
     <div class='chat-container'>
        <div class='sender'>
          #{data.sender} :
        </div>
        <div class='message'>
          #{data.message}
        </div>
      </div>
    "
    $("#chat-area").append(html)

  socket.on 'game:ended', (data)=>
    alert('game終了だ！去れ！ 別に帰れって言ってるわけじゃないんだからねっっっ//')

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