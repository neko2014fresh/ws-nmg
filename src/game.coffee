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
  playerMap = {}
  socketMap = {}

  constructor: (user_id) ->
    @state = @State['Start']
    @current_turn_owner = user_id

  start: (io)=>
    io.sockets.on "connection", (socket) =>

      socket.on 'get_all_country', =>
        Country.find {}, (err, country)=>
          params = 'countries': country
          io.sockets.emit 'all_country', params

      socket.on 'save_player_and_country', (data)=>
        player_name = data.player_name
        country = data.country

        player = new Player()
        player.name = player_name
        id = @createGameId()
        @addIds id
        player.game_id = id
        @playerMap['#{id}'] = player_name
        @socketMap['#{socket.id}'] = id
        player.country = country

        player.save (err)->
          console.log 'success for saving user:=>', player unless err

        Country.findOne {'name': country }, (err, c)=>
          console.log 'country:', c
          c.player_id = player.game_id
          c.player_name = player.name
          c.save (err)=>
            console.log 'success for saving country', c if err

        io.sockets.emit 'update_country', 'country': country, 'name': player_name

      socket.on 'turn:start', (data)=>
        console.log 'socketMap::', @socketMap
        @state = @State['Start']
        id = _.first @ids
        name = @playerMap["#{id}"]

        io.sockets.emit "turn:start_msg", {'turn_owner_name': name}

      socket.on 'turn:draw', (data)=>
        console.info "turn:draw"
        @state = @State['Draw']
        io.sockets.emit "turn:draw_end", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner, 'cardType': 'normal card'}

      socket.on 'turn:action', (data)=>
        # return unless @state is State['Draw']
        @state = @State['Action']
        # action_type = data.actionType
        io.sockets.emit "turn:action_selected", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner, 'actionType': 'sell to Thailand'}

      socket.on 'turn:bet', (data)=>
        # return unless @state is State['Draw']
        @state = @State['Bet']
        io.sockets.emit "turn:bet_end", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner}

      socket.on 'turn:finish', (data)=>
        # return unless @state is State['Draw']
        @state = @State['Finish']
        @shuffle_owner()

      socket.on 'turn:other', (data)=>
        @state = @state['Other']
        @otherEvent()

      socket.on 'turn:sample', (data)=>
        socket.emit "sample", "sample"
        io.sockets.emit "sample", "sample"

      socket.on 'disconnect', (data)=>
        console.info("disconnect")

  loop: =>
    @state = @State['IDLE']

  check_turn_and_correct_owner: (id)=>

  addIds: (id)=>
    @ids.push id

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