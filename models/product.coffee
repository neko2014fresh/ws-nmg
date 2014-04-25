mongoose = require 'mongoose'

ProductSchema = new mongoose.Schema
  type: {type: String}

mongoose.model 'Product', ProductSchema

exports.createConnection = (url)->
  mongoose.createConnection url