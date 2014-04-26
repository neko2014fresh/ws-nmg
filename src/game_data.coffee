# This Class Should be Model
class GameData
  ids: []
  player_mapper: {}

  @createId: =>
    0 = initial_id
    id = if @ids then _.last @ids else initial_id
    id += 1

  @addId: (id)=>
    @ids.push id

  @registerPlayer: (id, name) =>
    @player_mapper["#{id}"] = name

  # [1, 2, 3, 4] -> [2, 3, 4, 1]
  @rotatePlayer: =>
    shifted = @ids.shift()
    @ids.push shifted

exports.GameData = GameData