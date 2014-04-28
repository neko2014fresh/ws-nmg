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

      socket.on 'save_player_and_country', (data)=>
        console.log 'country selected'
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
          console.log 'country:', c
          c.player_id = player.game_id
          c.player_name = player.name
          c.save (err)=>
            console.log 'success for saving country' if err

        io.sockets.emit 'update_country_owner_name', 'country': country, 'name': player_name

      socket.on 'turn:init_start', (data)=>
        console.log 'turn:init_start'
        @state = @State['Start']
        id = ''
        for _id, _sock of @socketMap
          id = _id if _sock is socket.id
        name = @playerMap["#{id}"] unless id is ''
        console.log 'playerMap::', @playerMap
        @current_turn_owner = id

        io.sockets.emit "turn:setting_msg", { 'player': name }

      socket.on 'turn:start', (data)=>
        console.log 'turn:start'
        # console.log 'turn_owner...', @current_turn_owner
        # console.log 'socket_id....', socket.id
        # console.log 'socketMap...', @socketMap
        if @validate_turn_and_player @current_turn_owner, socket
          io.sockets.socket(socket.id).emit 'warn:not_your_turn'
          return
        name = @playerMap["#{@current_turn_owner}"]

        io.sockets.emit 'turn:starg_msg', { 'name': name }

      socket.on 'turn:draw', (data)=>
        console.info "turn:draw"
        @state = @State['Draw']
        if @validate_turn_and_player @current_turn_owner, socket
          console.log 'io.sockets.emit'
          console.log 'socket-id:::', socket.id
          console.log 'socketMap:::', @socketMap
          io.sockets.socket(socket.id).emit 'warn:not_your_turn'
          return

        io.sockets.socket(socket.id).emit('warn:already_draw') unless @cardStatus is ''
        card = Card.draw()
        @cardStatus = card
        io.sockets.emit "turn:draw_end", {'player': @playerMap["#{@current_turn_owner}"], 'cardType': card}

      socket.on 'turn:action', (data)=>
        @state = @State['Action']
        actionType = data.actionType
        @actionStatus = actionType

        switch actionType
          when 'buying'
            console.log 'cardを引いて下さい'
          when 'sell'
            console.log '売って下さい'
          when 'create_product'
            console.log '製造します'

        io.sockets.emit "turn:action_selected", {'turn_owner_name': @current_turn_owner, 'actionType': 'sell to Thailand'}

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
        msg = data.msg
        console.log 'msg:::', msg
        io.sockets.emit "chat:send", "msg": msg

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