--[[ A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe. ]]

ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed ('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof!! You Lost!!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!!', 0, 160, VIRTUAL_WIDTH,'center')
end

--[[if self.score == 5 then
    love.graphics.printf("Bronze Medal")
end

if self.score == 10 then
    love.graphics.printf("Silver Medal")
end

if self.score == 15 then
    love.graphics.printf("Gold Medal")
end]]