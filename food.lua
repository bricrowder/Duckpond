local food = {}
food.__index = food

function food.new(x, y, a, fsuid)
    local f = {}
    setmetatable (f, food)

    f.x = x
    f.y = y
    f.angle = a

    f.speed = 60        -- pixels per second
    f.throwtime = math.random(300,400) / 100        -- time
    f.currentthrowtime = 0   -- pixels
    f.lifetime = 15         -- life in second until it disappears, is also updated by "feeding"

    f.todestroy = false
    f.beingeaten = false

    f.fooduid = fsuid .. os.time()

    return f
end

function food:update(dt)

    -- update throw timer and movement
    self.currentthrowtime = self.currentthrowtime + dt
    if self.currentthrowtime <= self.throwtime then
        local tempspeed = self.speed
        if self.currentthrowtime >= self.throwtime / 3 then
            tempspeed = self.speed * 2
        end
        self.x = self.x + tempspeed * dt * math.cos(self.angle)
        self.y = self.y + tempspeed * dt * math.sin(self.angle)
    end

    -- update life timer and flag to be deleted
    self.lifetime = self.lifetime - dt
    if self.lifetime <= 0 then
        self.todestroy = true
    end
end

function food:draw()
    love.graphics.circle("fill", self.x, self.y, 4)
end

return food