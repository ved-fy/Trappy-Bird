push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

-- Actual window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual window size
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background.png')
-- Variable to implement parallax
local backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- Size of the background so we can keep looping the image
local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

-- Table to store all the pipes
local pipes = {}

-- Pipes will spawn after a time intervel. 'spawnTimer' keeps track of the time
local spawnTimer = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flappy bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return  false
    end
end

function love.update(dt)

    -- Adding the scroll speed to the image and the resetting to the intial point to make it look infinite
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH  

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    --update the bird
    bird:update(dt)

    for k, pipe in pairs(pipes) do
        -- Scrolls the pipe
        pipe:update(dt)

        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end
    -- Resetting the input table so we can query for further key presses
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    -- Drawing in layers
    -- Draw the background image first
    love.graphics.draw(background, -backgroundScroll, 0)

    -- Drawing pipes
    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    -- Drawing ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- Drawing bird
    bird:render()

    push:finish()
end

