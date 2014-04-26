$(->
  socket = io.connect()
  socket.on "connect", =>
    console.log "register connected"

  $('#register-country-btn').on 'click', ->
    player_name = $('#player-name').val()
    register_country = $('#register-country').val()
    # socket.emit 'player:register',
    #   'player_name': player_name
    #   'country'    : register_counry

    $.ajax 'finish_register',
      type: 'POST'
      data:
        'player_name': player_name
        'country': register_country
      complete:
        console.log 'success:register'

  # socket.on 'player:register_end', (data)->
  #   console.info("#{data.user_id}が#{data.country}を選びました")
  # $.get '/finish_register', =>
  #   console.info 'register end'

)