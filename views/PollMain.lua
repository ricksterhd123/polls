local pollMain = {
    gridlist = {},
    window = {},
    button = {}
}
pollMain.__index = pollMain
setmetatable(pollMain, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function pollMain:new(isAdmin, polls)
    self.polls = {}
end

function pollMain:update()

end

function pollMain:create()
    self.window[1] = guiCreateWindow(0.06, 0.09, 0.88, 0.83, "Poll window", true)
    guiWindowSetSizable(self.window[1], false)
    self.button[1] = guiCreateButton(0.78, 0.07, 0.20, 0.07, "Add", true, self.window[1])
    self.button[2] = guiCreateButton(0.78, 0.16, 0.20, 0.07, "Edit", true, self.window[1])
    self.button[3] = guiCreateButton(0.78, 0.25, 0.20, 0.07, "Archive", true, self.window[1])
    self.button[4] = guiCreateButton(0.78, 0.34, 0.20, 0.07, "Delete", true, self.window[1])

    self.gridlist[1] = guiCreateGridList(0.03, 0.06, 0.74, 0.92, true, self.window[1])
    guiGridListAddColumn(self.gridlist[1], "Description", 0.5)
    guiGridListAddColumn(self.gridlist[1], "Votes (YES/NO)", 0.5)

    guiGridListAddRow(self.gridlist[1])
    guiGridListSetItemText(self.gridlist[1], 0, 1, "Make superman invincible", false, false)
    guiGridListSetItemText(self.gridlist[1], 0, 2, "100/200", false, false)

end

function pollMain:destroy()

end

PollMain = pollMain