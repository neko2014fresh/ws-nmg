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
    $('#register-country-btn').on('click', function() {
      var player_name, register_country;
      player_name = $('#player-name').val() === "" ? "小保方晴子" : $('#player-name').val();
      register_country = $('#register-country').val();
      return socket.emit("save_player_and_country", {
        'player_name': player_name,
        'country': register_country
      });
    });
    $('#init-start').on('click', function() {
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
    socket.on('turn:country_selected', function(data) {
      return alert("" + data.user_id + "が" + data.country + "を選びました");
    });
    socket.on('turn:setting_msg', function(data) {
      return alert("" + data.player + "の初期設定が終わりました");
    });
    socket.on("turn:start_msg", function(data) {
      return alert("" + data.name + "のターンです");
    });
    socket.on('turn:draw_end', function(data) {
      console.info("draw_end");
      return alert(data.cardType);
    });
    socket.on('turn:action_selected', function(data) {
      return alert(data.actionType);
    });
    socket.on('all_country', function(data) {
      if ($('#countries').children().length === 0) {
        return _.map(data.countries, function(country) {
          var html;
          html = "          <br>          <div id='" + country.name + "' class='countries'>            <div class='country-name'>              国名:..." + country.name + "            </div>            <div class='market-scale'>              市場規模:..." + country.market_scale + "            </div>            <div class='market-rest'>              市場猶予:..." + country.market_rest + "            </div>            <div class='max-price'>              最高値:..." + country.max_price + "            </div>            <div class='buying_price'>              仕入れ値:..." + country.buying_price + "            </div>            <div class='owner'>              本社..." + country.player_name + "            </div>          </div>          <br>          ";
          return $('#countries').append(html);
        });
      }
    });
    socket.on('update_country_owner_name', function(data) {
      var country, player_name;
      country = data.country;
      player_name = data.name;
      return $('#' + ("" + country + " .owner")).html("本社..." + player_name);
    });
    socket.on("warn:not_your_turn", function(msg) {
      return alert('おめえのターンじゃねぇから！');
    });
    socket.on("warn:already_init", function(msg) {
      return alert('もう登録しとるやろ！');
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
