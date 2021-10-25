push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'pipePair'

--all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514

local bird = Bird()

-- our table of spawning PipePairs
local pipePairs = {}

-- our timer for spawning pipes
local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

--Scrolling variable to pause the game when we collide with a pipe
local scrolling = true

function love.load()

    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

     -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    --Kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --Initialize state machine with all state-returning functions
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')


    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end
-- Detects for data input 
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
        return false
    end

end

function love.update(dt)
    if scrolling then 

        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
        
        gStateMachine:update(dt)
    end
    
    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    
    --render logic to the currently active state
    gStateMachine:render()
   

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    --bird:render()
    push:finish()
end