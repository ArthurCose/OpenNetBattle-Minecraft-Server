local World = require("scripts/minecraft/world")
local Player = require("scripts/minecraft/player")
local Saves = require("scripts/minecraft/saves")

local world = World:new("default")
local players = {}

-- five minutes
Saves.save_every(world, 60 * 5, "world.json")
Saves.load(world, "world.json")

function tick()
  world:tick()

  for _, player in pairs(players) do
    player:tick()
  end
end

function handle_player_request(player_id)
  local player = Player:new(player_id)
  players[player_id] = player
  world:connect_player(player)
end

function handle_player_join(player_id)
  local player = players[player_id]

  player:handle_player_join()

  if player.instance then
    player.instance.world:handle_player_join(player)
  end
end

function handle_player_disconnect(player_id)
  local player = players[player_id]

  if player.instance then
    player.instance.world:disconnect_player(player)
  end

  players[player_id] = nil
end

function handle_actor_interaction(player_id, other_id, button)
  local player = players[player_id]
  player:handle_actor_interaction(other_id, button)
end

function handle_tile_interaction(player_id, x, y, z, button)
  local player = players[player_id]
  player:handle_tile_interaction(x, y, z, button)
end

function handle_post_selection(player_id, post_id)
  local player = players[player_id]
  player:handle_post_selection(post_id)
end

function handle_board_close(player_id)
  local player = players[player_id]
  player:handle_board_close()
end

function handle_textbox_response(player_id, response)
  local player = players[player_id]
  player:handle_textbox_response(response)
end

function handle_player_move(player_id, x, y, z)
  local player = players[player_id]
  player:handle_player_move(x, y, z)
end

function handle_player_avatar_change(player_id, details)
  local player = players[player_id]
  player:handle_player_avatar_change(details)
end

function handle_player_emote(player_id, emote)
  local player = players[player_id]

  if not player.instance then
    return
  end

  for _, p in pairs(player.instance.world.players) do
    p.instance:handle_player_emote(player, emote)
  end
end
