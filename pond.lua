local pond = {}
pond.__index = pond

function pond.new(pondfile)
    local p = {}
    setmetatable(p, pond)

    -- declare the different parts
    p.water = {}
    p.bank = {}
    p.waves = {}
    p.wateredge = {direction = -1}
    

    -- open, parse and assign pond file data
    for l in love.filesystem.lines("data/" .. pondfile .. ".csv") do
        -- parse data
        local s = string.find(l,",")
        local type = l:sub(1,s-1)   -- start to first comma
        
        if type == "water" then
            -- this keeps finding the next comma, the last variable doesn't need to find the end 
            local s2 = string.find(l,",",s+1)
            p.water.texture = love.graphics.newImage(l:sub(s+1,s2-1))
            
            local s3 = string.find(l,",",s2+1)
            p.water.x = tonumber(l:sub(s2+1,s3-1))
            
            p.water.y = tonumber(l:sub(s3+1))         
        elseif type == "waves" then
            -- this keeps finding the next comma, the last variable doesn't need to find the end 
            local s2 = string.find(l,",",s+1)
            p.waves.texture = love.graphics.newImage(l:sub(s+1,s2-1))
            
            local s3 = string.find(l,",",s2+1)
            p.waves.wavesspeed = tonumber(l:sub(s2+1,s3-1))
            
            local s4 = string.find(l,",",s3+1)
            p.waves.x = tonumber(l:sub(s3+1,s4-1))
            
            local s5 = string.find(l,",",s4+1)
            p.waves.y = tonumber(l:sub(s4+1,s5-1))
            
            local s6 = string.find(l,",",s4+1)
            p.waves.x2 = tonumber(l:sub(s5+1,s6-1))
            
            p.waves.y2 = tonumber(l:sub(s6+1))                  
        elseif type == "bank" then
            -- this keeps finding the next comma, the last variable doesn't need to find the end 
            local s2 = string.find(l,",",s+1)
            p.bank.texture = love.graphics.newImage(l:sub(s+1,s2-1))
            
            local s3 = string.find(l,",",s2+1)
            p.bank.x = tonumber(l:sub(s2+1,s3-1))
            
            p.bank.y = tonumber(l:sub(s3+1))            
        elseif type == "wateredge" then
            -- this keeps finding the next comma, the last variable doesn't need to find the end 
            local s2 = string.find(l,",",s+1)
            p.wateredge.texture = love.graphics.newImage(l:sub(s+1,s2-1))
            
            -- movement speed / second
            local s3 = string.find(l,",",s2+1)
            p.wateredge.speed = tonumber(l:sub(s2+1,s3-1))
            
            local s4 = string.find(l,",",s3+1)
            p.wateredge.maxmovement = tonumber(l:sub(s3+1,s4-1))

            local s5 = string.find(l,",",s4+1)
            p.wateredge.x = tonumber(l:sub(s4+1,s5-1))
            
            p.wateredge.y = tonumber(l:sub(s5+1))
            p.wateredge.oy = p.wateredge.y      -- save the starting y value for comparison later
        end
    end

    return p
end

function pond:update(dt)
    -- update
    self.wateredge.y = self.wateredge.y + self.wateredge.speed * dt * self.wateredge.direction
    if self.wateredge.y <= self.wateredge.oy - self.wateredge.maxmovement or self.wateredge.y >= self.wateredge.oy + self.wateredge.maxmovement then
        self.wateredge.direction = self.wateredge.direction * -1
    end
end

function pond:draw()
    love.graphics.draw(self.bank.texture, self.bank.x, self.bank.y)
    love.graphics.draw(self.wateredge.texture, self.wateredge.x, math.floor(self.wateredge.y))
    love.graphics.draw(self.water.texture, self.water.x, self.water.y)
    love.graphics.draw(self.waves.texture, self.waves.x, self.waves.y)
end


return pond