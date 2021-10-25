Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = 430
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH

    --self.y = math.random(VIRTUAL_HEIGHT/ 4, VIRTUAL_HEIGHT-10)
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    --self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
    0, -- rotation
    1, -- X scale
    self.orientation == 'top' and -1 or 1) -- Y scale
end