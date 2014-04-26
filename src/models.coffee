mongoose = require 'mongoose'

PlayerSchema = new mongoose.Schema
  name: type: String
  cache: type: Number, default: 30.0
  income: type: Number, default: 0.0
  player_id: type: Number
  country: type: String
  number_of_product: type: Number, default: 0

ProductSchema = new mongoose.Schema
  type: type: String

CountrySchema = new mongoose.Schema
  name: type: String
  market_scale: type: Number
  market_rest: type: Number, default: 0
  max_price: type: Number
  buying_price: type: Number
  player_id: type: Number

url = 'mongodb://127.0.0.1/ws-nmg'

db = mongoose.createConnection url, (err, res)->
  console.log 'err:', err if err

exports.Player  = db.model 'Player', PlayerSchema
exports.Product = db.model 'Product', ProductSchema
exports.Country = db.model 'Country', CountrySchema
