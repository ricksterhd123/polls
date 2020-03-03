-- TODO: Add base class for all views
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

--[[
pollMain constructor
Params:
    bool isAdmin - Is the localPlayer an admin?
    table polls - The set of (PollID, Title, Description) TODO: including archived
    table pollsVoted - The set of (PollID, votedYes) for the localPlayer
]]
function pollMain:new(isAdmin, polls, pollsVoted)
    self.isAdmin = isAdmin or false
    self.polls = polls or {}
    self.pollsVoted = pollsVoted or {}
    iprint("self.polls", self.polls)
end

--[[ 
Set the view with data
Params:
    bool isAdmin - Is the localPlayer an admin?
    table polls - The set of (PollID, Title, Description) TODO: including archived
    table pollsVoted - The set of (PollID, votedYes) for the localPlayer
Returns:
    bool success - should something go wrong then return false
]]
function pollMain:update(isAdmin, polls, pollsVoted)
    self.polls = polls or self.polls
    self.pollsVoted = pollsVoted or self.pollsVoted
    self:resetGridList()

    -- Reset list of archived polls and reset
    -- buttons if now available because the localPlayer is an Admin
    -- TODO
end

--[[
Create the GUI elements and set visible
]]
function pollMain:show()
    iprint("pollMain:show", self.polls)
    self.window[1] = guiCreateWindow(0.06, 0.09, 0.88, 0.83, "Poll window", true)
    self.button[1] = guiCreateButton(0.78, 0.07, 0.20, 0.07, "Add", true, self.window[1])
    self.button[2] = guiCreateButton(0.78, 0.16, 0.20, 0.07, "Edit", true, self.window[1])
    self.button[3] = guiCreateButton(0.78, 0.25, 0.20, 0.07, "Archive", true, self.window[1])
    self.button[4] = guiCreateButton(0.78, 0.34, 0.20, 0.07, "Delete", true, self.window[1])
    self.gridlist[1] = guiCreateGridList(0.03, 0.06, 0.74, 0.92, true, self.window[1])
    guiWindowSetSizable(self.window[1], false)
    iprint("pollMain:show2", self.polls)
    self:resetGridList()
    iprint("happened")
end

--[[
Reset GridList and other elements
]]
function pollMain:resetGridList()
    iprint("self.gridlist", self.gridlist[1])
    iprint("self.polls", self.polls)
    if not self.gridlist[1] or not self.polls then return false end
    guiGridListClear(self.gridlist[1])
    guiGridListAddColumn(self.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(self.gridlist[1], "Description", 0.5)
    guiGridListAddColumn(self.gridlist[1], "Votes (YES/NO)", 0.2)
    guiGridListAddColumn(self.gridlist[1], "Voted", 0.2)

    for i, poll in ipairs(self.polls) do
        local rowid = guiGridListAddRow(self.gridlist[1])
        -- ID
        guiGridListSetItemText(self.gridlist[1], rowid, 1, poll.ID, false, false)
        -- Title
        guiGridListSetItemText(self.gridlist[1], rowid, 2, poll.Title, false, false)
        -- Votes YES/NO
        guiGridListSetItemText(self.gridlist[1], rowid, 3, poll.VotesYes.."/"..poll.VotesNo, false, false)
        -- Voted
        guiGridListSetItemText(self.gridlist[1], rowid, 4, tostring(poll.PlayerVoted), false, false)
    end
    return true
end

--[[
Call this before you're done, to destroy all GUI elements and member variables
]]
function pollMain:destroy()
    destroyElement(self.window[1])
    self.polls = nil
    self.pollsVoted = nil
    self.window = nil
    self.button = nil
    self.gridlist = nil
    return true
end

PollMain = pollMain