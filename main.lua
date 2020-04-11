push = require 'push'

Class = require 'class'

require 'Bird'

-- Pipe calss we've written
require 'Pipe'

-- Class repesentation of pipe pairs together
require 'PipePair'
l̥
-- All clsses related to state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'

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
local pipePairs = {}

-- Pipes will spawn after a time intervel. 'spawnTimer' keeps track of the time
local spawnTimer = 0

-- Check if we want to keep going
local scrolling = true

-- initialize our last recorded y value for a gap placement between pipes
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flappy bird')

    -- Initialising retro fonts
    smallFont = love.graphics.newFont('font/font.ttf', 8)
    mediumFont = love.graphics.newFont('font/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('font/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Intiializing state machines with state returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

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
            
    -- update the state machine
    gStateMachine:update(dt)    
            
    -- Resetting the input table so we can query for further key presses
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    -- Drawing in layers
    -- Draw the background image first
    love.graphics.draw(background, -backgroundScroll, 0)
    -- Render state
    gStateMachine:render()
    -- Drawing ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
