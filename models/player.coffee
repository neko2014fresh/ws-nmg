mongoose = require 'mongoose'


PlayerSchema = new mongoose.Schema
  name: {type: String}
  score: {type: Number}
  player_id: {type: Number}

mongoose.model 'Player', CountrySchema

exports.createConnection = (url)->
  mongoose.createConnection url
