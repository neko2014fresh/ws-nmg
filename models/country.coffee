mongoose = require 'mongoose'

CountrySchema = new mongoose.Schema
  name: {type: String}
  market_scale: {type: Number}
  market_rest: {type: Number}
  max_price: {type: Number}
  buying_price: {type: Number}
  owner_id: {type: Number}

mongoose.model 'Country', CountrySchema

exports.createConnection = (url)->
  mongoose.createConnection url