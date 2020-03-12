-- model base class
local model = {}
model.__index = model
setmetatable(model, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
      end,
})

function model:new(dbObject, SQLTable)
    assert(dbObject, "Database object false or nil")
    self.dbObject = dbObject
    local result = self.dbObject:exec(SQLTable) -- CREATE IF NOT EXISTS etc
    assert(result, "Could not create table")
    return self
end

function model:add(insertString, ...)
    return self.dbObject:exec(insertString, unpack(arg))
end

function model:update(updateString, ...)
    return self.dbObject:exec(updateString, unpack(arg))
end

function model:get(query, ...)
    return self.dbObject:query(query, unpack(arg))
end

-- polls implements model
local polls = {}
polls.__index = polls
setmetatable(polls, {
    __index = model,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
      end,
})

function polls:new(dbObject)
    model.new(self, dbObject, [[
        CREATE TABLE IF NOT EXISTS `polls` (
            ID INTEGER PRIMARY KEY,
            Title VARCHAR(255),
            Description VARCHAR(255),
            Archived INTEGER,
        )
    ]])
    iprint("polls table created")
    return self
end

function polls:add(title, description)
    return model.add(self, "INSERT INTO `polls` (Title, Description, Archived) VALUES (?, ?, 0)", title, description)
end

function polls:update(ID, newTitle, newDescription, archived)
    archived = archived and "1" or "0"
    return model.update(self, "UPDATE `polls` SET Title = ?, Description = ? WHERE ID = ?", newTitle, newDescription, ID)
end

function polls:get()
    return model.get(self, "SELECT * FROM `polls`")
end

-- votes implements model
local votes = {}
votes.__index = votes
setmetatable(votes, {
    __index = model,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
      end,
})

function votes:new(dbObject)
    model.new(self, dbObject, [[
        CREATE TABLE IF NOT EXISTS `votes` (
            ID INTEGER NOT NULL,
            PollID INTEGER NOT NULL,
            Account VARCHAR(255),
            Vote INTEGER,
            PRIMARY KEY (ID),
            FOREIGN KEY (PollID) REFERENCES polls(ID)
        )
    ]])
    iprint("votes table created")
    return self
end

function votes:add(pollID, accountName, votedYes)
    if votedYes then
        votedYes = 1
    else
        votedYes = 0
    end
    return model.add(self, "INSERT INTO `votes` (PollID, Account, Vote) VALUES (?, ?, ?)", pollID, accountName, votedYes)
end

function votes:get(pollID)
    return model.get(self, "SELECT * FROM `votes` WHERE PollID = ?", pollID)
end

Votes = votes
Polls = polls
