ModelWrapper = ->
  create: (model_name)=>
    countryModel = require './models/#{model_name}'
    db = countryModel.createConnection 'mongodb://127.0.0.1/{model_name}'
    Country = db.model _.str.capitalize("#{model_name}")
