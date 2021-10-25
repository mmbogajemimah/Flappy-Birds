PipePair = Class{}
-- size of the gap between pipes

local GAP_HEIGHT = math.random(85, 110)

function PipePair:init(y)
     -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32
    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y 
    
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT) 
    }

    self.remove = false

    self.scored = false

end

function PipePair:update(dt) 
    if self.x > - PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x 
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
