ws-nmg
======

どうせ出来なくても怒られるだけなので、チャレンジしよう、
ということでNodeを使います

- Socket.io
- Express
- jade
- CoffeeScript

あたりかな

##Getting start

```
$ git clone git@github.com:neko2014fresh/ws-nmg.git
$ cd ws-nmg
$ npm install
$ coffee app.coffee
```

##クライアントサイドのcoffeeのコンパイル

```
$ offee -wc public/javascripts/*.coffee
```

- saveのタイミングで、`coffee`のファイルをjsに変換する

##Rails側から、どうやってuser-idを渡すか。
