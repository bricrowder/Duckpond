local player = {}
player.__index = player

function player.new()
    local p = {}
    setmetatable (p, player)

    return p
end

return player