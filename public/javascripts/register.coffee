$(->
  socket = io.connect()
  socket.on "connect", =>
    console.log "register connected"

  $('#register-country-btn').on 'click', ->
    player_name = $('#player-name').val()
    register_country = $('#register-country').val()

    $.ajax 'sample_register',
      type: 'POST'
      data:
        'player_name': player_name
        'country': register_country
      complete:
        console.log 'success:register'
  )