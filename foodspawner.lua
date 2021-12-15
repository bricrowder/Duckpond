local foodspawner = {}
foodspawner.__index = foodspawner

function foodspawner.new()
    local f = {}
    setmetatable (f, foodspawner)

    return f
end

return foodspawner