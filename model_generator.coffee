ModelWrapper = ->
  create: (model_name)=>
    countryModel = require './models/{#model_name}'
    db = countryModel.createConnection 'mongodb://127.0.0.1/ws-nmg'
    mod_name_cap = _.str.capitalize("#{model_name}")
    mod_name_cap = db.model mod_name_cap
    exports."#{mod_name_cap}" = mod_name_cap