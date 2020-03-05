--[[
    Used for voting or reading.
]]
local pollVote = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}
pollVote.__index = pollVote
setmetatable(pollVote, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function pollVote:new(poll)
    self.visible = false
    self.id = poll.ID
    self.title = poll.Title
    self.description = poll.Description
    self.voted = poll.PlayerVoted  -- has user already voted?
    self:create()
end

function pollVote:create()
    self.window[1] = guiCreateWindow(0.32, 0.20, 0.36, 0.60, "Vote", true)
    guiWindowSetSizable(self.window[1], false)
    self.memo[1] = guiCreateMemo(0.03, 0.28, 0.93, 0.57, "", true, self.window[1])
    self.edit[1] = guiCreateEdit(0.03, 0.14, 0.88, 0.07, "", true, self.window[1])
    self.label[1] = guiCreateLabel(0.03, 0.08, 0.88, 0.06, "Title:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[1], "center")
    self.label[2] = guiCreateLabel(0.03, 0.22, 0.88, 0.06, "Description:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[2], "center")
    self.button[1] = guiCreateButton(0.04, 0.88, 0.17, 0.09, "YES", true, self.window[1])
    self.button[2] = guiCreateButton(0.24, 0.88, 0.17, 0.09, "NO", true, self.window[1])
    self.button[3] = guiCreateButton(0.43, 0.88, 0.24, 0.09, "Back", true, self.window[1])
    guiSetVisible(self.window[1], false)
    self:update()
end

function pollVote:update()
    guiSetText(self.edit[1], self.title)
    guiSetText(self.memo[1], self.description)
    -- User cannot click these buttons because they have already voted.
    guiSetEnabled(self.button[1], not self.voted)
    guiSetEnabled(self.button[2], not self.voted)
end

-- TODO: Think of a better name
function pollVote:setPoll(poll)
    self.id = poll.ID
    self.title = poll.Title
    self.description = poll.Description
    self.voted = poll.PlayerVoted  -- has user already voted?
    self:update()
end

function pollVote:setVisible(bool)
    self.visible = bool
    guiSetVisible(self.window[1], bool)
end

function pollVote:destroy()
    destroyElement(self.window[1])
    self.window = nil
    self.button = nil
    self.label = nil
    self.edit = nil
    self.memo = nil
    self.id = nil
    self.title = nil
    self.description = nil
    self.voted = nil
end
PollVote = pollVote