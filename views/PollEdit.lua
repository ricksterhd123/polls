
local pollEdit = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}

pollEdit.__index = pollEdit
setmetatable(pollEdit, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function pollEdit:new(pollID, title, description)
    self.id = pollID
    self.title = title
    self.description = description
    self.visible = false
    if not pollID then
        self.mode = false
        self.title = ""
        self.description = ""
        self.id = -1
    else
        self.mode = true
        -- TODO: this shouldn't happen
        if not self.title then self.title = "" end
        if not self.description then self.description = "" end
    end
    self:create()
end

function pollEdit:create()
    self.window[1] = guiCreateWindow(0.32, 0.20, 0.36, 0.60, (self.mode and "Edit" or "Create").." poll", true)
    guiWindowSetSizable(self.window[1], false)
    self.memo[1] = guiCreateMemo(0.03, 0.28, 0.93, 0.57, self.description, true, self.window[1])
    self.edit[1] = guiCreateEdit(0.03, 0.14, 0.88, 0.07, self.title, true, self.window[1])
    self.label[1] = guiCreateLabel(0.03, 0.08, 0.88, 0.06, "Title:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[1], "center")
    self.label[2] = guiCreateLabel(0.03, 0.22, 0.88, 0.06, "Description:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[2], "center")
    self.button[1] = guiCreateButton(0.04, 0.89, 0.33, 0.09, self.mode and "Edit poll" or "Add poll", true, self.window[1])
    self.button[2] = guiCreateButton(0.40, 0.89, 0.33, 0.09, "Back", true, self.window[1])
    guiSetVisible(self.window[1], false)
    self:update()
end

function pollEdit:update()
    guiSetText(self.edit[1], self.title)
    guiSetText(self.memo[1], self.description)
    guiSetText(self.button[1], self.mode and "Edit poll" or "Add poll")
    guiSetText(self.window[1], (self.mode and "Edit" or "Create").." poll")
end

-- false = add
-- true  = edit
function pollEdit:setMode(mode)
    self.mode = mode
    self:update()
end

function pollEdit:setPoll(poll)
    if not poll then return end
    self.id = poll.ID
    self.title = poll.Title
    self.description = poll.Description
    self:update()
end

function pollEdit:clear()
    self.id = -1
    self.title = ""
    self.description = ""
    self:update()
end

function pollEdit:setVisible(bool)
    self.visible = bool
    guiSetVisible(self.window[1], bool)
    if bool then guiFocus(self.window[1]) end
end

function pollEdit:getPollID()
    if self.id == -1 then return false end
    return self.id
end

function pollEdit:getTitleDescription()
    local title = guiGetText(self.edit[1])
    local description = guiGetText(self.memo[1])
    -- TODO: this should be in update
    self.title = title
    self.description = description
    return title, description
end

function pollEdit:destroy()
    destroyElement(self.window[1])
    self.window = nil
    self.edit   = nil
    self.memo   = nil
    self.label  = nil
    self.button = nil
    self.title  = nil
    self.description = nil
    self.visible = nil
    self.mode = nil
end

PollEdit = pollEdit