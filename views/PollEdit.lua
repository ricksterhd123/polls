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

function pollEdit:new()
    self.polls = {}
end

function pollEdit:create()
    self.window[1] = guiCreateWindow(0.32, 0.20, 0.36, 0.60, "Create poll", true)
    guiWindowSetSizable(self.window[1], false)
    self.memo[1] = guiCreateMemo(0.03, 0.28, 0.93, 0.57, "", true, self.window[1])
    self.edit[1] = guiCreateEdit(0.03, 0.14, 0.88, 0.07, "", true, self.window[1])
    self.label[1] = guiCreateLabel(0.03, 0.08, 0.88, 0.06, "Title:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[1], "center")
    self.label[2] = guiCreateLabel(0.03, 0.22, 0.88, 0.06, "Description:", true, self.window[1])
    guiLabelSetVerticalAlign(self.label[2], "center")
    self.button[1] = guiCreateButton(0.04, 0.89, 0.33, 0.09, "Create Poll", true, self.window[1])
    self.button[2] = guiCreateButton(0.40, 0.89, 0.33, 0.09, "Back", true, self.window[1])
end

function pollEdit:destroy()

end

PollEdit = pollEdit