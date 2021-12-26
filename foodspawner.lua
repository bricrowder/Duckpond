local foodclass = require "food"

local foodspawner = {}
foodspawner.__index = foodspawner

function foodspawner.new(x, y)
    local f = {}
    setmetatable (f, foodspawner)

    f.x = x
    f.y = y
    f.angle = math.pi/2     -- direction that the food is thrown, initialized to straight down

    f.timebetweenthrows = 3
    f.throwtimer = 0

    f.food = {}

    return f
end

function foodspawner:update(dt)
    -- update food
    for i, v in ipairs(self.food) do
        v:update(dt)
    end
    
    -- find food to get rid of
    local todestory = {}
    for i, v in ipairs(self.food) do
        if v.todestroy then
            table.insert(todestroy, i)
        end
    end

    -- get rid of it
    if todestroy then
        for i = #todestroy, 1, -1 do
            table.remove(self.food,todestroy[i])
        end
    end
    
    -- throw food
    self.throwtimer = self.throwtimer + dt
    if self.throwtimer >= self.timebetweenthrows then
        -- reset, more exact then just 0 reset
        self.throwtimer = self.throwtimer - self.timebetweenthrows

        -- spawn a new food!
        table.insert(self.food, foodclass.new(self.x, self.y, self.angle))
    end
end

function foodspawner:draw()
    love.graphics.circle("fill", self.x, self.y, 16)

    for i, v in ipairs(self.food) do
        v:draw()
    end
end

return foodspawner