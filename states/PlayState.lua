--[[
    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24 

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --update timer for pipe spawning
    self.timer = self.timer + dt

    --spawn a new pipe pair every second and a half
    if self.timer > math.random(2, 4) then
        local y = math.max(-PIPE_HEIGHT + 10,
    math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    self.lastY = y 

     -- add a new pipe pair at the end of the screen at our new Y
     table.insert(self.pipePairs, PipePair(y))

     self.timer = 0
    end

    -- for every pair of pipes
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                sounds['score']:play()
                pair.scored = true
            end
        end
        --update position
        pair:update(dt)
    end
    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs (self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    --update bird based on gravity and input
    self.bird:update(dt)
    -- Simple collission between bird and all pipes in pairs
    for k, pair in pairs (self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides (pipe) then
                sounds['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    --reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs (self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    self.bird:render()
end