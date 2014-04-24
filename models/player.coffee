mongoose = require 'mongoose'


PlayerSchema = new mongoose.Schema
  name: {type: String}
  cache: {type: Number}
  income: {type: Number}
  player_id: {type: Number}
  number_of_product: {type: Number}

mongoose.model 'Player', PlayerSchema

exports.createConnection = (url)->
  mongoose.createConnection url
