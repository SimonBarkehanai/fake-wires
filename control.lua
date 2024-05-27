---@param player LuaPlayer
---@param item data.ItemID
local function give(player, item)
    if player.clear_cursor() then
        player.cursor_stack.set_stack(item)
    end
end

---@param event EventData.on_lua_shortcut | EventData.CustomInputEvent
local function on_shortcut(event)
    local name = event.prototype_name or event.input_name
    if name:sub(1, 10) ~= "fake-wires" then return end

    local player = game.players[event.player_index]
    if not player.cursor_stack then return end

    give(player, name:sub(12))
end

script.on_event({
    defines.events.on_lua_shortcut,
    "fake-wires-copper-cable",
    "fake-wires-red-wire",
    "fake-wires-green-wire",
}, on_shortcut)
