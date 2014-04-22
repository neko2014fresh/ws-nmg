class Game
  State:
    'Start'  : 0
    'Draw'   : 1
    'Action' : 2
    'Bet'    : 3
    'Finish' : 4
    'Other'  : 5
    'Idle'   : 6

  constructor: (user_id) ->
    @state = @State['Start']
    @current_turn_owner = user_id

  start: (io)=>
    io.sockets.on "connection", (socket) =>
      socket.on 'turn:start', (data)=>
        @state = @State['Start']
        socket.broadcast.emit "turn:start_msg", {'turn_owner_id': @current_turn_owner, 'msg': 'カードを引いて下さい'}

      socket.on 'turn:draw', (data)=>
        @state = @State['Draw']
        socket.broadcast.emit "turn:draw", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner}

      socket.on 'turn:action', (data)=>
        @state = @State['Action']
        socket.broadcast.emit "turn:action", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner}

      socket.on 'turn:bet', (data)=>
        @state = @State['Bet']
        socket.broadcast.emit "turn:bet", {'turn_owner_id': @current_turn_owner, 'turn_owner_name': @current_turn_owner}

      socket.on 'turn:finish', (data)=>
        @state = @State['Finish']
        @shuffle_owner()

      socket.on 'turn:other', (data)=>
        @state = @state['Other']
        @otherEvent()

      socket.on 'turn:sample', (data)=>
        socket.emit "sample", "sample"
        socket.broadcast.emit "sample", "sample"

  loop: =>
    @state = @State['IDLE']

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