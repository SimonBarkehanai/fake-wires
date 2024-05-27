---@param name data.ItemID
---@return data.ItemPrototype
local function fake_wire(name)
    local orig = data.raw["item"][name]
    local fake = table.deepcopy(orig)
    fake.name = "fake-" .. fake.name
    fake.localised_name = { "item-name." .. name }
    fake.localised_description = { "item-description." .. name }

    return fake
end

---@param wire data.ItemID
---@param key_sequence string
---@return data.CustomInputPrototype
local function wire_hotkey(wire, key_sequence)
    ---@type data.CustomInputPrototype
    return {
        type = "custom-input",
        name = "fake-wires-" .. wire,
        key_sequence = key_sequence,
        action = "lua",
        consuming = "none"
    }
end

---@param wire data.ItemID
---@return data.ShortcutPrototype
local function wire_shortcut(wire)
    local item = data.raw["item"][wire]
    ---@type data.ShortcutPrototype
    return {
        type = "shortcut",
        name = "fake-wires-" .. wire,
        order = "w[wire]-g[" .. wire .. "]",
        action = "lua",
        associated_control_input = "fake-wires-" .. wire,
        localised_name = { "shortcut.fake-wires-" .. wire },
        icon = {
            filename = item.icon,
        },
    }
end

data:extend({
    fake_wire("copper-cable"),
    fake_wire("red-wire"),
    fake_wire("green-wire"),
    wire_hotkey("copper-cable", "ALT + C"),
    wire_hotkey("red-wire", "ALT + F"),
    wire_hotkey("green-wire", "ALT + G"),
    wire_shortcut("copper-cable"),
    wire_shortcut("red-wire"),
    wire_shortcut("green-wire"),
})
