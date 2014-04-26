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
        country = data.register_country

        player = new Player()
        player.name = player_name
        # player.id = GameData.createGameId()
        # GameData.addId player.id
        # GameData.registerPlayer "#{player.id}": "#{player.name}"  
        player.country = country

        player.save (err)->
          console.log 'success for saving user' unless err
        io.sockets.emit 'update_country', 'country': country, 'name': player_name

      socket.on 'turn:country', (data) =>
        @state = @State['Select']
        io.sockets.emit "turn:country_selected", { 'user_id': 0, 'country': 'Thailand', 'clients': '' }

      socket.on 'turn:start', (data)=>
        @state = @State['Start']
        io.sockets.emit "turn:start_msg", {'turn_owner_id': @current_turn_owner, 'msg': 'カードを引いて下さい'}

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

  check_turn_and_correct_owner: ()=>


  shuffle_owner: =>
    @current_turn_owner += 1

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