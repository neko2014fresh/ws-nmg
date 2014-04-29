mongoose = require 'mongoose'

PlayerSchema = new mongoose.Schema
  name: type: String
  cache: type: Number, default: 30.0
  income: type: Number, default: 0.0
  game_id: type: Number
  country: type: String
  number_of_product: type: Number, default: 0

ProductSchema = new mongoose.Schema
  type: type: String

CountrySchema = new mongoose.Schema
  name: type: String, unique: true
  market_scale: type: Number
  market_rest: type: Number, default: 0
  max_price: type: Number
  buying_price: type: Number
  player_id: type: Number
  player_name: type: String

GameDataSchema = new mongoose.Schema
  player_ids: type: [], values: [Number]

CalculatorSchema = new mongoose.Schema
  net_profit: type: Number, default: 30.0
  cache: type: Number, default: 30.0

  sales: type: Number, default: 0.0
  debt: type: Number, default: 0.0
  investment_sales: type: Number, default: 0.0
  asset_sales: type: Number, default: 0.0
  stock_cost: type: Number, default: 0.0
  labor_expenses: type: Number, default: 0.0
  chip_expenses: type: Number, default: 0.0
  rental_expenses: type: Number, default: 0.0
  other_expenses: type: Number, default: 0.0
  interest: type: Number, default: 0.0
  back_debt: type: Number, default: 0.0
  extra_loss: type: Number, default: 0.0
  asset_payment: type: Number, default: 0.0

  number_products: type: Number, default: 0.0
  number_employees: type: Number, default: 1.0

  initial_number_products: type: Number, default: 0.0
  initial_number_employees: type: Number, default: 1.0
  initial_cache: type: Number, default: 30.0
  initial_inventory: type: Number, default: 0.0
  initial_surplus: type: Number, default: 0.0
  initial_capital: type: Number, default: 30.0
  initialdebt: type: Number, default: 0.0




url = 'mongodb://127.0.0.1/ws-nmg'

db = mongoose.createConnection url, (err, res)->
  console.log 'err:', err if err

exports.Player  = db.model 'Player', PlayerSchema
exports.Product = db.model 'Product', ProductSchema
exports.Country = db.model 'Country', CountrySchema
exports.GameData = db.model 'GameData', GameDataSchema
exports.Calculator = db.model 'Calculator', CalculatorSchema