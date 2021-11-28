-- game objects --
local playerclass
local duckclass
local foodspawnerclass
local pondclass = require "pond"

-- global game variables --
local mode              -- menu, game, hiscore
local player            -- player object
local ducks             -- list of npc ducks
local foodspawners      -- list of food spawners
local food              -- list of food
local backgroundcolour  -- window colour
local background        -- play area background
local pond              -- pond on screen

-- main menu variables --
local menutitle         -- menu title
local menubuttons       -- list of menu buttons
local menuindex         -- index of the selected menu item
local menuitemcount     -- count of menuitems


local hiscores          -- list of names and scores



function love.load()
    -- set the mode to start in the menu
    mode = "menu"

    -- set background colour
    backgroundcolour = {0.3, 0.3, 1.0, 1.0}

    -- load pond as a menu background
    pond = pondclass.new("pond1")

    -- load / define the menu title
    menutitle = {
        text = love.graphics.newText(love.graphics.newFont(48), {{1.0, 0.8, 0.8, 1.0}, "Duck Pond Legend!"}),
        x = 35,
        y = 35
    }

    -- load / define the menu buttons
    menuindex = 1
    menuitemcount = 2
    menubuttons = {
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
    for i, v in ipairs(menubuttons) do
        local w, h = v.text:getDimensions()
        v.w = w
        v.h = h
        -- set max to this if it is bigger
        if w > max then
            max = w
        end
    end
    -- set them all to max now
    for i, v in ipairs(menubuttons) do
        v.w = max
    end

    -- define and load hiscore file and UI related elements
    hiscores = {}
    hiscores.list = {}
    hiscores.text = love.graphics.newText(love.graphics.newFont(24),"")
    hiscores.title = love.graphics.newText(love.graphics.newFont(24),"TOP 10 LEGENDS!")
    hiscores.titleposition = {x = 500, y = 160}
    hiscores.rectposition = {x = 500, y = 200, w = 220, h = 380}
    hiscores.tableposition = {x = 520, y = 220}

    local counter = 0
    local basecolour = {0.8, 0.8, 1.0, 1.0}
    local colourinc = 0.4
    local colourdir = -1

    for l in love.filesystem.lines("data/hiscore.csv") do
        -- split string
        local s = string.find(l,",")
        local name = l:sub(1,s-1)
        local score = l:sub(s+1)
        table.insert(hiscores.list, {name=name, score=score})
        -- create colour based on current gradient
        local colour = {
            basecolour[1] + colourinc,
            basecolour[2] + colourinc,
            basecolour[3],
            1.0,
        }
        -- update colour gradient, switch directions if necessary
        colourinc = colourinc + (0.1 * colourdir)
        if colourinc >= 0.4 or colourinc <= 0 then
            colourdir = colourdir * -1
        end
        -- write to text object
        hiscores.text:add({colour,name}, 0, counter * 35)
        hiscores.text:add({colour,score}, 100, counter * 35)
        -- update line counter
        counter = counter + 1
    end
end

function love.keypressed(key)
    if mode == "menu" then
        -- move menuitem up/down
        if key == "down" then
            menuindex = menuindex + 1
            if menuindex > menuitemcount then
                menuindex = 1
            end
        elseif key == "up" then
            menuindex = menuindex - 1
            if menuindex < 1 then
                menuindex = menuitemcount
            end
        -- select menuitem 
        elseif key == "space" then
            if menuindex == 1 then
                -- start a new game
            elseif menuindex == 2 then
                -- quit
                love.event.quit()
            end
        end
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end    

end

function love.mousepressed(x, y, button)
    if mode == "menu" then
        -- see if the mouse clicked a button, only check selected
        if button == 1 then
            local v = menubuttons[menuindex]
            if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
                if menuindex == 1 then
                    -- start game
                elseif menuindex == 2 then
                    love.event.quit()
                end
            end
        end
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end    
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()

    if mode == "menu" then

        -- check for menu item hits
        for i, v in ipairs(menubuttons) do
            if mx >= v.x and mx <= v.x+v.w and my >= v.y and my <= v.y+v.h then
                menuindex = i
            end
        end
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end
end

function love.draw()
    love.graphics.clear(backgroundcolour)
    if mode == "menu" then
        -- draw pond
        pond:draw()

        -- draw title
        love.graphics.draw(menutitle.text, menutitle.x, menutitle.y)

        -- draw menu
        for i, v in ipairs(menubuttons) do
            love.graphics.draw(v.text, v.x, v.y)
        end

        -- draw selected menu item
        love.graphics.setLineWidth(4)
        local m = menubuttons[menuindex]
        love.graphics.rectangle("line", m.x-16, m.y-8, m.w+32, m.h+16)

        -- draw hiscore box
        -- to be formatted better!
        love.graphics.draw(hiscores.title, hiscores.titleposition.x, hiscores.titleposition.y)
        love.graphics.rectangle("line", hiscores.rectposition.x, hiscores.rectposition.y, hiscores.rectposition.w, hiscores.rectposition.h)
        love.graphics.draw(hiscores.text, hiscores.tableposition.x, hiscores.tableposition.y)

        love.graphics.setLineWidth(1)

    elseif mode == "game" then

    elseif mode == "hiscore" then

    end
end