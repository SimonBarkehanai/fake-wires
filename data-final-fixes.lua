local to_replace = {
    ["copper-cable"] = "fake-copper-cable",
    ["red-wire"] = "fake-red-wire",
    ["green-wire"] = "fake-green-wire",
}

---@param items data.IngredientPrototype[] | data.ProductPrototype[]
---@return string[]
local function remove_or_replace_wire(items)
    local replaced = {}
    if not items then return {} end
    for _, item in ipairs(items) do
        if item then
            if item[1] and to_replace[item[1]] then
                replaced[#replaced + 1] = item[1]
                item[1] = to_replace[item[1]]
            elseif item.name and to_replace[item.name] then
                replaced[#replaced + 1] = item.name
                item.name = to_replace[item.name]
            end
        end
    end
    return replaced
end

local replaced_ing = {
    ["copper-cable"] = {},
    ["red-wire"] = {},
    ["green-wire"] = {},
}
local replaced_res = {
    ["copper-cable"] = {},
    ["red-wire"] = {},
    ["green-wire"] = {},
}

for _, recipe in pairs(data.raw["recipe"]) do
    for _, c in ipairs({ recipe, recipe.expensive, recipe.normal }) do
        if c then
            if c.result and to_replace[c.result] then
                table.insert(replaced_res[c.result], c.name)
                c.result = to_replace[c.result]
            end
            local rep = remove_or_replace_wire(c.ingredients)
            for _, r in ipairs(rep) do
                table.insert(replaced_ing[r], c.name)
            end
            rep = remove_or_replace_wire(c.results)
            for _, r in ipairs(rep) do
                table.insert(replaced_res[r], c.name)
            end
        end
    end
end

for i, r in pairs(replaced_ing) do
    if #r == 0 then
        table.insert(data.raw["item"][i], "hidden")
        for _, name in ipairs(replaced_res[i]) do
            data.raw["recipe"][name].enabled = false
            data.raw["recipe"][name].hidden = true
        end
    end
end

for _, name in ipairs({ "copper-cable", "red-wire", "green-wire" }) do
    local orig = data.raw["item"][name]
    orig.flags = orig.flags or {}

    data.raw["item"]["fake-" .. name] = table.deepcopy(orig)
    local fake = data.raw["item"]["fake-" .. name]
    fake.name = "fake-" .. name
    fake.localised_name = fake.localised_name or { "item-name." .. name }
    fake.localised_description = fake.localised_description or { "item-description." .. name }

    table.insert(orig.flags, "only-in-cursor")
    table.insert(orig.flags, "hidden")

    local i = orig.icon and orig or orig.icons[1]
    data.raw["shortcut"]["fake-wires-" .. name].icon = {
        filename = i.icon,
        size = i.icon_size,
        mipmap_count = i.icon_mipmaps,
    }
end
