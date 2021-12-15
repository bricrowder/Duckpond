local pondclass = require "pond"

local menu = {}
menu.__index = menu

function menu.new()
    local m = {}
    setmetatable(m, menu)

    -- Title
    m.menutitle = {
        text = love.graphics.newText(love.graphics.newFont(48), {{1.0, 0.8, 0.8, 1.0}, "Duck Pond Legend!"}),
        x = 35,
        y = 35
    }

    -- load / define the menu buttons
    m.menuindex = 1
    m.menuitemcount = 2
    m.menubuttons = {
        {
            text = love.graphics.newText(love.graphics.newFont(24),"Become a Legend!"),
            x = 140,
            y = 420
        },
        {
            text = love.graphics.newText(love.graphics.newFont(24),"Quit"),
            x = 140,
            y = 470
        }
    }
    -- set the width and height of the menu buttons based on the largest text size
    local max = 0
    for i, v in ipairs(m.menubuttons) do
        local w, h = v.text:getDimensions()
        v.w = w
        v.h = h
        -- set max to this if it is bigger
        if w > max then
            max = w
        end
    end
    -- set them all to max now
    for i, v in ipairs(m.menubuttons) do
        v.w = max
    end
    
    -- background pond
    m.pond = pondclass.new("pond1")

    return m
end

function menu:keypressed(key)
    if key == "down" then
        self.menuindex = self.menuindex + 1
        if self.menuindex > self.menuitemcount then
            self.menuindex = 1
        end
    elseif key == "up" then
        self.menuindex = self.menuindex - 1
        if self.menuindex < 1 then
            self.menuindex = self.menuitemcount
        end
    -- select menuitem 
    elseif key == "space" then
        if self.menuindex == 1 then
            print "got here!"
            -- create a new game and set the mode to game - calls it from main.lua function so that it is created under that namespace, not the menu
            createGame()

        elseif self.menuindex == 2 then
            -- quit
            love.event.quit()
        end
    end    
end

function menu:mousepressed(x, y, button)
    if button == 1 then
        local v = self.menubuttons[self.menuindex]
        if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
            if self.menuindex == 1 then
                createGame()
            elseif self.menuindex == 2 then
                love.event.quit()
            end
        end
    end
end

function menu:update(dt)
    local mx, my = love.mouse.getPosition()

    -- update background pond
    self.pond:update(dt)

    -- check for menu item hits
    for i, v in ipairs(self.menubuttons) do
        if mx >= v.x and mx <= v.x+v.w and my >= v.y and my <= v.y+v.h then
            self.menuindex = i
        end
    end
end

function menu:draw()
    -- draw background pond
    self.pond:draw()


    -- draw title
    love.graphics.draw(self.menutitle.text, self.menutitle.x, self.menutitle.y)

    -- draw menu
    for i, v in ipairs(self.menubuttons) do
        love.graphics.draw(v.text, v.x, v.y)
    end

    -- draw selected menu item
    love.graphics.setLineWidth(4)
    local m = self.menubuttons[self.menuindex]
    love.graphics.rectangle("line", m.x-16, m.y-8, m.w+32, m.h+16)
    love.graphics.setLineWidth(1)
end

return menu