class Game
  State:
    'Start'  : 0
    'Draw'   : 1
    'Action' : 2
    'Bet'    : 3
    'Finish' : 4
    'Other'  : 5
    'Idle'   : 6
    'Select' : 7
  ids: []
  playerMap: {}
  socketMap: {}
  cardStatus: ''
  actionStatus: ''
  current_turn_owner: 0

  constructor: ->
    @state = @State['Start']

  start: (io)=>
    io.sockets.on "connection", (socket) =>

      socket.on 'get_all_country', =>
        Country.find {}, (err, country)=>
          params = 'countries': country
          io.sockets.emit 'all_country', params

      socket.on 'get_all_chat', =>
        Chat.find {}, (err, chat)=>
          params = 'chats': chat
          console.log 'chat::obj', params
          io.sockets.emit 'all_chat', params

      socket.on 'get_current_turn_owner', =>
        player_id = @getTurnPlayer()
        player_name = if player_id then @playerMap["#{player_id}"] else ''
        params = 
          'turn_owner_name': player_name
        io.sockets.emit 'current_turn_owner', params

      socket.on 'save_player_and_country', (data)=>
        console.log 'country selected'
        console.log 'client-data::::::', data
        player_name = data.player_name
        country = data.country

        player = new Player()
        player.name = player_name
        id = @createGameId()
        @addIds id
        player.game_id = id
        @playerMap["#{id}"] = player_name

        if socket.id in @socketMap
          io.sockets.socket(socket.id).emit 'warn:already_init'
          return

        @socketMap["#{id}"] = socket.id
        player.country = country

        player.save (err)->
          console.log 'success for saving user' unless err

        Country.findOne {'name': country }, (err, c)=>
          c.player_id = player.game_id
          c.player_name = player.name
          c.save (err)=>
            console.log 'success for saving country' if err

        io.sockets.emit 'update_country_owner_name', 'country': country, 'name': player_name
        io.sockets.socket(socket.id).emit 'initial_player_status', 'country': country, 'name': player_name, 'cash': player.cash, 'income': player.income, 'product': player.number_of_product

      socket.on 'turn:init_start', (data)=>
        console.log 'turn:init_start'
        @state = @State['Start']
        id = ''
        for _id, _sock of @socketMap
          id = _id if _sock is socket.id
        name = @playerMap["#{id}"] unless id is ''
        @current_turn_owner = id

        io.sockets.emit "turn:setting_msg", { 'player': name }

      socket.on 'turn:start', (data)=>
        console.log 'turn:start'
        if @validate_turn_and_player @current_turn_owner, socket
          io.sockets.socket(socket.id).emit 'warn:not_your_turn'
          return
        name = @playerMap["#{@current_turn_owner}"]
        io.sockets.emit 'turn:start_msg', { 'name': name }

      socket.on 'turn:draw', (data)=>
        console.info "turn:draw"
        @state = @State['Draw']
        if @validate_turn_and_player @current_turn_owner, socket
          io.sockets.socket(socket.id).emit 'warn:not_your_turn'
          return

        io.sockets.socket(socket.id).emit('warn:already_draw') unless @cardStatus is ''
        card = Card.draw()
        @cardStatus = card
        io.sockets.emit "turn:draw_end", { 'player': @playerMap["#{@current_turn_owner}"], 'cardType': card }

      socket.on 'turn:action', (data)=>
        @state = @State['Action']
        actionType = data.actionType
        @actionStatus = actionType

        console.log 'turn:action'

        io.sockets.socket(socket.id).emit "turn:action_selected", {"action": actionType}

      socket.on 'turn:buy', (data)=>
        console.log 'buying'
        country = data.country
        amount = data.amount
        console.log 'turn:buy::amount', amount
        price = 0
        market_rest = ''
        cash = ''
        number_of_product = ''

        # should have instance method
        Country.findOne {'name': country}, (err, c)=>
          c.market_rest += amount
          price = c.buying_price
          market_rest = c.market_rest
          if c.market_rest > c.market_scale
            io.sockets.socket(socket.id).emit 'warn:cant_buy_from_country'
            return
          c.save (err) ->
            console.log err if err

          params = 
            'name': country
            'market_rest': market_rest

          console.log 'country-params::', params

          io.sockets.emit "turn:action_end_for_country", params

        # should have instance method
        player_name = @playerMap["#{@current_turn_owner}"]
        Player.findOne 'name': player_name, (err, p)=>
          console.log 'find_player:', p
          p.number_of_product += amount
          expenditure = (price * amount)
          p.cash -= expenditure
          number_of_product = p.number_of_product
          cash = p.cash
          p.save (err) ->
            console.log err

          params = 
            'player': player_name
            'cash': cash
            'number_of_product': number_of_product

          io.sockets.emit "turn:action_end_for_player", params

      socket.on 'turn:sell', (data)=>
        console.log 'sell'
        country = data.country
        amount = data.amount
        price = 0
        market_rest = ''
        cash = ''
        number_of_product = ''

        Country.findOne 'name': country, (err, c)=>
          c.market_rest = c.market_rest - amount
          price = c.max_price
          market_rest = c.market_rest
          if c.market_rest < 0
            io.sockets.socket(socket.id).emit 'warn:cant_sell_to_country'
            return
          c.save (err) ->
            console.log err if err
          params = 
            'name': country
            'market_rest': market_rest
          io.sockets.emit "turn:action_end_for_country", params

        # should have instance method
        player_name = @playerMap["#{@current_turn_owner}"]
        Player.findOne 'name': player_name, (err, p)=>
          tmp_income = (price * amount)
          p.cash += tmp_income
          p.number_of_product += amount
          number_of_product = p.number_of_product
          cash = p.cash
          p.save (err) ->
            console.log err

          params = 
            'player': player_name
            'cash': cash
            'number_of_product': number_of_product

          io.sockets.emit "turn:action_end_for_player", params



      socket.on 'turn:bet', (data)=>
        # return unless @state is State['Draw']
        @state = @State['Bet']
        io.sockets.emit "turn:bet_end", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner}

      socket.on 'turn:finish', (data)=>
        # return unless @state is State['Draw']
        @state = @State['Finish']
        @rotatePlayer()
        id = @getTurnPlayer()
        console.log 'player::', @playerMap
        # console.log 'player::', @playerMap["#{id}"]
        @cardStatus = ''
        io.sockets.emit "turn:finished", {"player_name": @playerMap["#{id}"]}

      socket.on 'turn:other', (data)=>
        @state = @state['Other']
        @otherEvent()

      socket.on 'chat:on', (data)=>
        player_id = @getPlayerBySockId socket.id
        player_name = @playerMap["#{player_id}"]

        # chat
        chat = new Chat()
        chat.sender  = if player_name then player_name else 'player'
        chat.message = data.msg
        chat.save (err)->
          console.log 'Err:', err if err

        io.sockets.emit "chat:send", "sender": chat.sender, "message": chat.message

      socket.on 'game:end', (data)=>
        name = @playerMap[@getPlayerBySockId(socket.id)]
        cash = 30.0
        income = 0.0
        email = ''
        Player.find {'name': name}, (err, p)->
          cash = p.cash
          income = p.income
          email = p.email

        con = mysql.createConnection
          host: Conf.host
          user: Conf.user
          password: Conf.password
          database: Conf.database
        con.connect()
        
        email = 'r-fujiwara@nekojarashi.com'
        q = 'UPDATE users SET cashe = ?, net_profit = ? WHERE email = ?'
        con.query q, [cash, income, email], (err, rows, fields)=>
          console.log 'sql error:', err if err

        con.end()
        io.sockets.emit 'game:ended', "name": email

      socket.on 'turn:sample', (data)=>
        socket.emit "sample", "sample"
        io.sockets.emit "sample", "sample"

      socket.on 'disconnect', (data)=>
        console.info("disconnect")

  loop: =>
    @state = @State['IDLE']

  validate_turn_and_player: (player_id, socket)=>
    return true unless @socketMap["#{player_id}"] is socket.id

  addIds: (id)=>
    @ids.push id
    console.log 'addIds:::', @ids

  getTurnPlayer: =>
    _.first @ids

  getPlayerBySockId: (sock_id)=>
    for id, _sock_id of @socketMap
      id if sock_id == _sock_id

  createGameId: =>
    initial_id = 0
    id = if @ids.length != 0 then _.last @ids else initial_id
    id += 1

  rotatePlayer: =>
    shifted = @ids.shift()
    @ids.push shifted

  cardEvent: =>
    @sockets.on 'card:onDraw', =>
      @socket.broadcast.emit 'notify:drawed', {'card_id': data.id, 'turn_owner_id': @current_turn_owner}

  actionEvent: =>
    @sockets.on 'action:onAction', =>

  betEvent: =>
    @sockets.on 'bet:onBet', =>

  otherEvent: =>
    @loop()

exports.Game = Game