local duck = {}
duck.__index = duck

function duck.new()
    local d = {}
    setmetatable (d, duck)

    local ducknumber = math.random(1,1)
    local duckfile = "assets/duck" .. ducknumber .. ".png"
    local duckeatfiles = {"assets/duck" .. ducknumber .. "eat1.png", "assets/duck" .. ducknumber .. "eat2.png"}
    local duckcleanfiles = {"assets/duck" .. ducknumber .. "clean1.png", "assets/duck" .. ducknumber .. "clean2.png"}

    d.x = math.random(50, 750)
    d.y = math.random(150, 550)
    d.angle = math.random(1,628) / 100
    d.speed = math.random(30,50)
    d.flip = 1          -- x scale, use -1 to flip sprite
    d.texture = love.graphics.newImage(duckfile)
    d.mode = "pause"     -- move, turn, pause, eat, clean
    d.actiontime = math.random(6,8)   -- in seconds, time to pick an action
    d.timer = 0         -- the counter for the actiontimer and the actions, i can reuse it
    d.adjust = false        -- if a duck is getting a signal to adjust its path, for duck on duck collisions
    d.movetime = 10     -- in seconds
    d.pausetime = 3     -- in seconds
    d.eattime = 2       -- in seconds
    d.cleantime = 3     -- in seconds
    d.bounds = {x=50, y=200, w=700, h=400}       -- need to load this from somewhere
    d.turnspeed = math.pi/4     -- rotation speed, radians per second, when duck is turning
    d.turning = false       -- if duck is turning or not
    d.turntime = 3          -- in seconds - how long the turn is
    d.timerturning = 0      -- counter to increment that checks against turntime
    d.turnchecktime = 10        -- in seconds
    d.timerturncheck = 0        -- in seconds
    d.cx = 0
    d.cy = 0
    d.chasing = false       -- if duck is chasing a target/food
    d.chaseradius = 300     -- pixel length basically
    -- check again how to use pythag for the check, did it a ton in that flying / planet game

    -- initialize animation variables and and frames
    d.animtimer = 0
    d.eat = {
        texture = {
            love.graphics.newImage(duckeatfiles[1]),
            love.graphics.newImage(duckeatfiles[2])
        },
        framespeed = 0.5,
        frame = 1
    }
    d.clean = {
        texture = {
            love.graphics.newImage(duckcleanfiles[1]),
            love.graphics.newImage(duckcleanfiles[2])
        },
        framespeed = 0.25,
        frame = 1
    }
    return d

end

function duck:update(dt)

    -- add a chase mode here

    if self.mode == "move" then

        -- move the duck
        self.x = self.x + self.speed * dt * math.cos(self.angle)
        self.y = self.y + self.speed * dt * math.sin(self.angle)

        -- check to see if the duck should turn
        self.cx = self.x + 100 * math.cos(self.angle)
        self.cy = self.y + 100 * math.sin(self.angle)

        if not self.turning then
            local timetoturn = false

            if self.cx < self.bounds.x then
                timetoturn = true
            elseif self.cx > self.bounds.x + self.bounds.w then
                timetoturn = true
            end
            if self.cy < self.bounds.y then
                timetoturn = true
            elseif self.cy > self.bounds.y + self.bounds.h then
                timetoturn = true
            end

            if timetoturn or self.adjust then
                self.turning = true
                self.turnspeed = math.random(75,157)/100
                local x = math.random(1,2)      -- random negative direction
                if x == 2 then
                    self.turnspeed = self.turnspeed * -1
                end
                self.turntime = math.random(1,2)      -- in seconds
            end

        else
            -- turning
            self.angle = self.angle + self.turnspeed * dt

            -- bound it to 1..628
            if self.angle < 0 then 
                self.angle = math.pi*2 + self.angle
            elseif self.angle > math.pi*2 then
                self.angle = self.angle - math.pi*2
            end

            -- check if we are done turning
            self.timerturning = self.timerturning + dt
            if self.timerturning >= self.turntime then
                self.timerturning = 0
                self.turning = false
            end
        end

        -- bounds check it, turn if you hit a wall
        if self.x < self.bounds.x then
            self.x = self.bounds.x
            self:changeangle()
        elseif self.x > self.bounds.x + self.bounds.w then
            self.x = self.bounds.x + self.bounds.w
            self:changeangle()
        end
        if self.y < self.bounds.y then
            self.y = self.bounds.y
            self:changeangle()
        elseif self.y > self.bounds.y + self.bounds.h then
            self.y = self.bounds.y + self.bounds.h
            self:changeangle()
        end
        
        -- adjust if there are any other ducks in your way


        self.timer = self.timer + dt
        if self.timer >= self.movetime then
            self.timer = 0
            self.mode = "pause"
        end

    elseif self.mode == "pause" then
        -- pause is the default mode
        self.timer = self.timer + dt
        if self.timer >= self.actiontime then
            self.timer = 0
            
            local action = math.random(1,2)

            if action == 1 then
                self.mode = "move"
            elseif action == 2 then
                self.mode = "eat"
                self.animtimer = 0
            elseif action == 3 then
                self.mode = "clean"
                self.animtimer = 0
            end
        end

    elseif self.mode == "eat" then
        -- update the frame #
        self.animtimer = self.animtimer + dt
        if self.animtimer >= self.eat.framespeed then
            self.animtimer = self.animtimer - self.eat.framespeed
            self.eat.frame = self.eat.frame + 1
            if self.eat.frame > #self.eat.texture then
                self.eat.frame = 1
            end
        end

        -- update the action time
        self.timer = self.timer + dt
        if self.timer >= self.eattime then
            self.timer = 0
            self.mode = "pause"
        end
    elseif self.mode == "clean" then
        -- update the frame #
        self.animtimer = self.animtimer + dt
        if self.animtimer >= self.clean.framespeed then
            self.animtimer = self.animtimer - self.clean.framespeed
            self.clean.frame = self.clean.frame + 1
            if self.clean.frame > # self.clean.texture then
                self.clean.frame = 1
            end
        end

        -- update the action time        
        self.timer = self.timer + dt
        if self.timer >= self.cleantime then
            self.timer = 0
            self.mode = "pause"
        end
    end
    self:setDir()
    
    -- reset adjust flag
    self.adjust = false
end

function duck:draw()
    if self.mode == "eat" then
        love.graphics.draw(self.eat.texture[self.eat.frame], self.x, self.y, 0, self.flip, 1, self.texture:getWidth()/2, self.texture:getHeight()/2)
    elseif self.mode == "clean" then
        love.graphics.draw(self.clean.texture[self.clean.frame], self.x, self.y, 0, self.flip, 1, self.texture:getWidth()/2, self.texture:getHeight()/2)
    else
        love.graphics.draw(self.texture, self.x, self.y, 0, self.flip, 1, self.texture:getWidth()/2, self.texture:getHeight()/2)
    end
    -- love.graphicss.circle("fill",self.cx, self.cy, 8)
    -- love.graphics.print(self.x .. " " .. self.y, 10, 10)
    -- love.graphics.print(self.angle, 10, 25)
    -- love.graphics.print(self.flip, 10, 40)
    -- love.graphics.print(self.mode, 10, 55)
end

function duck:changeangle()
    local a = self.angle + math.pi      -- do a 180
    local d = math.random(-157,157) / 100       -- then randomize up to 90 degrees on either side - 1.57 is pi/2, or 90 degrees
    self.angle = a + d
end

function duck:setDir()
    if self.angle >= math.pi/2 and self.angle <= math.pi*3/2 then
        self.flip = -1
    else
        self.flip = 1
    end
end

return duck