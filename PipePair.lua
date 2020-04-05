PipePair = Class {}

-- Size of the gap between pipes
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- Initialize pipe to past the edge of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost pipes
    self.y = y

    -- Instantiate 2 pipes that belong to the same pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Is the pipe ready to be removed from the scene
    self.remove = false

    -- Checking if we went past the pair of pipes ( equivalent to scoring )
    self.scored = false
end

function PipePair:update(dt)
    -- Removing pipe if its not beyond the screen
    if self.x > -PIPE_WIDTH then
        self.x = self. x - PIPE_SPEED * dt
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