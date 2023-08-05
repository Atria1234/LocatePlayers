function on_lua_shortcut(event)
	if event.prototype_name == 'LocatePlayers__locate-next-player' then
        locate_next_player(event)
	end
end

function locate_next_player(event)
    local target_player_index = get_next_player_index(event.player_index)
    if target_player_index ~= nil then
        target_player = game.connected_players[target_player_index]
        if target_player.character and target_player.character.valid then
            game.players[event.player_index].zoom_to_world(target_player.position, 1, target_player.character)
        else
            game.players[event.player_index].zoom_to_world(target_player.position, 1)
        end
    end
end

function get_next_player_index(player_index)
    local last_index = global.player_last_index[player_index] or 0
    local player_count = table_size(game.connected_players)

    if player_count == 1 then
        return nil
    end

    last_index = (last_index + 1) % player_count

    if game.connected_players[last_index + 1].index == player_index then
        last_index = (last_index + 1) % player_count
    end

    global.player_last_index[player_index] = last_index
    return last_index + 1
end

local function init_globals()
    if global.player_last_index == nil then
        global.player_last_index = {}
    end
end

script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
script.on_event("LocatePlayers__locate-next-player", locate_next_player)

script.on_init(init_globals)
script.on_configuration_changed(init_globals)
