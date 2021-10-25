--[[Counts down visually on the screen (3,2,1) so that the player knows the game is about to begin. 
    Transitions to the PlayState as soon as the countdown is complete.]]

CountdownState = Class {__includes = BaseState}

COUNNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNNTDOWN_TIME then
        self.timer = self.timer % COUNNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end