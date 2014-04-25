class Card

  @draw = ->
    cardType = @generateRandom
    risk = @riskType if cardType is 'risk'

  generateRandom: ->
    random = Math.floor(Math.random() * 5)
    #1/5でリスクカードを引く
    if random is 0 then 'risk' else 'normal'

  riskType: =>
    random = Math.floor(Math.random() * 2)
    ['死ぬ', 'ちゃんとしないと死ぬ'][random]