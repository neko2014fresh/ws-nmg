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
$ coffee -wc public/javascripts/*.coffee
```

- saveのタイミングで、`coffee`のファイルをjsに変換する

##Pry的なDebugをNodeで行う

- node-inspectorをインストール

```
$ npm install -g node-inspector

#以下のoption渡して起動
$ coffee --nodejs --debug-brk some.coffee

#some.coffeeのどこかにdebuggerを挟んでおく
$ node-inspector

$ open http://127.0.0.1:8080/debug?port=5858
```
