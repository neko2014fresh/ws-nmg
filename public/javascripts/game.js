// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var socket,
      _this = this;
    console.log('loaded');
    socket = io.connect();
    socket.on("connect", function() {
      return console.log("connected");
    });
    setTimeout(function() {
      return console.info('check update');
    }, 1000);
    socket.emit('get_all_country');
    socket.emit('get_all_chat');
    socket.emit('get_current_turn_owner');
    $('#register-country-btn').on('click', function() {
      var player_name, register_country;
      player_name = $('#player-name-form').val() === "" ? "小保方晴子" : $('#player-name-form').val();
      register_country = $('#register-country').val();
      return socket.emit("save_player_and_country", {
        'player_name': player_name,
        'country': register_country
      });
    });
    $('#init-start').on('click', function() {
      socket.emit('get_current_turn_owner');
      return socket.emit('turn:init_start');
    });
    $('#start').on('click', function() {
      return socket.emit('turn:start');
    });
    $('#draw_card').on('click', function() {
      console.info("draw card");
      return socket.emit('turn:draw');
    });
    $('#sample').on('click', function() {
      return socket.emit('turn:sample');
    });
    $('#action-btn').on('click', function() {
      var action_type;
      action_type = $('#action-type').val();
      return socket.emit('turn:action', {
        'actionType': action_type
      });
    });
    $('#turn_end').on('click', function() {
      return socket.emit('turn:finish');
    });
    $('#chat-button').on('click', function() {
      var chat;
      chat = $("#chat-msg").val();
      $("#chat-msg").val("");
      return socket.emit('chat:on', {
        "msg": chat
      });
    });
    $('#game-end').on('click', function() {
      socket.emit('game:end');
      return alert("" + data.user_id + "が" + data.country + "を選びました。");
    });
    socket.on('turn:setting_msg', function(data) {
      return alert("" + data.player + "の初期設定が終わりました。");
    });
    socket.on("turn:start_msg", function(data) {
      return alert("" + data.name + "のターンです。");
    });
    socket.on('turn:draw_end', function(data) {
      console.info("draw_end");
      return alert("" + data.player + "が" + data.cardType + "を引きました。" + data.player + "は行動を選択して下さい");
    });
    socket.on('turn:action_selected', function(data) {
      var actionType, amount, targetCountry;
      actionType = data.action;
      targetCountry = $('#target-country').val();
      amount = $('#amount').val();
      return socket.emit("turn:" + actionType, {
        'country': targetCountry,
        'amount': amount
      });
    });
    socket.on("turn:action_end_for_country", function(data) {
      return $("#" + ("" + data.name) + " .market-rest").html("" + data.market_rest);
    });
    socket.on("turn:action_end_for_player", function(data) {
      $('#game-status #cash .value').html(data.cash);
      return $('#game-status #stock .value').html(data.number_of_product);
    });
    socket.on('all_country', function(data) {
      if ($('#countries tbody').children().length === 0) {
        return _.map(data.countries, function(country) {
          var html;
          html = "          <tr id='" + country.name + "'>            <td class='country-name'> " + country.name + " </td>            <td class='market-scale'> " + country.market_scale + " </td>            <td class='market-rest'> " + country.market_rest + " </td>            <td class='max-price'> " + country.max_price + " </td>            <td class='buying_price'> " + country.buying_price + " </td>            <td class='owner'> " + country.player_name + " </td>          </tr>        ";
          return $('#countries tbody').append(html);
        });
      }
    });
    socket.on('all_chat', function(data) {
      if ($('#chat-area').children().length === 0) {
        return _.map(data.chats, function(chat) {
          var html;
          html = "        <div class='chat-container'>          <div class='sender'>            " + chat.sender + " :          </div>          <div class='message'>            " + chat.message + "          </div>        </div>        ";
          return $('#chat-area').append(html);
        });
      }
    });
    socket.on('update_country_owner_name', function(data) {
      var country, player_name;
      country = data.country;
      player_name = data.name;
      return $('#' + ("" + country + " .owner")).html("本社..." + player_name);
    });
    socket.on('current_turn_owner', function(data) {
      return $('#game-status #turn-owner .value').html(data.turn_owner_name);
    });
    socket.on('initial_player_status', function(data) {
      $('#game-status #player-name .value').html(data.name);
      $('#game-status #cash .value').html(data.cash);
      return $('#game-status #stock .value').html(data.product);
    });
    socket.on("warn:not_your_turn", function(msg) {
      return alert('おめえのターンじゃねぇから！');
    });
    socket.on("chat:send", function(data) {
      var html;
      html = "     <div class='chat-container'>        <div class='sender'>          " + data.sender + " :        </div>        <div class='message'>          " + data.message + "        </div>      </div>    ";
      return $("#chat-area").append(html);
    });
    socket.on('warn:cant_buy_from_country', function(data) {
      return alert('残念やけどそっからは買えんて');
    });
    socket.on('game:ended', function(data) {
      return alert('game終了だ！去れ！ 別に帰れって言ってるわけじゃないんだからねっっっ//');
    });
    socket.on("warn:already_init", function(msg) {
      return alert('もう登録しとるやろ！');
    });
    socket.on("warn:already_draw", function(msg) {
      return alert('もう引いとるやろ！');
    });
    socket.on("turn:finished", function(data) {
      return alert("ターン終了。次は" + data.player_name + "のターンです");
    });
    socket.on("msg:push", function(msg) {
      var date;
      date = new Date();
      return console.info('push');
    });
    return socket.on("msg updateDB", function() {
      return console.info('msg');
    });
  });

}).call(this);
