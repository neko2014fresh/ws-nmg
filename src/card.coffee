class Card

  @draw = =>
    cardType = @generateRandom()
    if cardType is 'risk'
      risk = @riskType()
    else
      cardType

  @generateRandom: =>
    random = Math.floor(Math.random() * 5)
    #1/5でリスクカードを引く
    if random is 0 then 'risk' else 'normal card'

  @riskType: =>
    random = Math.floor(Math.random() * 2)
    # console.log "r-randomNum:", random
    ['死ぬ', 'ちゃんとしないと死ぬ'][random]

exports.Card = Card