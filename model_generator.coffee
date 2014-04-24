class ModelGenerator

  @create: (model_name)=>
    countryModel = require './models/country'
    db = countryModel.createConnection 'mongodb://127.0.0.1/countries'
    Country = db.model 'Country'

