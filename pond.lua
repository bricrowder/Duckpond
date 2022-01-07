local pond = {}
pond.__index = pond

function pond.new(pondfile)
    local p = {}
    setmetatable(p, pond)

    -- declare the different parts
    p.bank = {}
    
    p.watershader = love.graphics.newShader("shaders/water.glsl")
    p.transshader = love.graphics.newShader("shaders/transparent.glsl")

    p.transshader:send("starta", 1.0)

    p.bank.texture = love.graphics.newImage("assets/pond1-bank.png")
    p.bank.x = 0
    p.bank.y = 0

    p.ripples = {}

    p.canvas = love.graphics.newCanvas(800,600-p.bank.texture:getHeight())
    p.artefactcanvas = love.graphics.newCanvas(200,(600-p.bank.texture:getHeight())/2)
    p.artefactx = -800
    p.artefactspeed = 5

    p.artefacts = {}
    
    for i = 1, 200 do
        p.artefacts[i] = {}
        for j = 1, 105 do
            p.artefacts[i][j] = love.math.noise(i * math.random() * 2, j * math.random() * 2)
        end
    end

    -- make water reflection canvas
    love.graphics.setCanvas(p.artefactcanvas)
    for i = 1, 200 do
        for j = 1, 105 do
            if p.artefacts[i][j] < 0.3 then
                love.graphics.setColor(0.1,0.2,0.2,0.75)
                love.graphics.points(i,j)
            elseif p.artefacts[i][j] > 0.95 then
                love.graphics.setColor(0.5,0.5,0.6,0.75)
                love.graphics.points(i,j)
            end
        end
    end    

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()


    p.timer = 0



    return p
end

function pond:update(dt)
    self.timer = self.timer + dt
    self.watershader:send("time", self.timer)

    self.artefactx = self.artefactx + dt * self.artefactspeed

    if self.artefactx >= 0 then
        self.artefactx = self.artefactx - 800
    end
end

function pond:draw(d)
    love.graphics.clear(0.05,0.05,0.1,1.0)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.bank.texture, self.bank.x, self.bank.y)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0,0,0,0)
    -- love.graphics.setColor(0.2,0.2,0.3,1)
    self.transshader:send("starta", 1.0)
    love.graphics.setShader(self.transshader)
    love.graphics.draw(self.bank.texture, 0, self.bank.texture:getHeight(),0 , 1 ,-1)
    love.graphics.setShader()
    love.graphics.setColor(1,1,1,1)

    if d then
        for i, v in ipairs(d) do
            if #v.ripples > 0 then
                v:drawRipples(self.bank.texture:getHeight())
            end

            love.graphics.setColor(1,1,1,0.5)

            if v.mode == "eat" then
                love.graphics.draw(v.eat.texture[v.eat.frame], v.x, v.y-self.bank.texture:getHeight()+v.texture:getHeight(), 0, v.flip, -1, v.texture:getWidth()/2, v.texture:getHeight()/2)
            elseif v.mode == "clean" then
                love.graphics.draw(v.clean.texture[v.clean.frame], v.x, v.y-self.bank.texture:getHeight()+v.texture:getHeight(), 0, v.flip, -1, v.texture:getWidth()/2, v.texture:getHeight()/2)
            else
                love.graphics.draw(v.texture, v.x, v.y-self.bank.texture:getHeight()+v.texture:getHeight(), 0, v.flip, -1, v.texture:getWidth()/2, v.texture:getHeight()/2)
            end

        end
    end
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(self.artefactcanvas, self.artefactx, 0, 0, 4)
    love.graphics.draw(self.artefactcanvas, self.artefactx+800, 0, 0, 4)

    -- draw ripples here
    love.graphics.setCanvas()
    love.graphics.setShader(self.watershader)
    love.graphics.draw(self.canvas, 0, self.bank.texture:getHeight())
    love.graphics.setShader()
end



return pond