--[[
    Database helper class
]]
local db = {}
db.__index = db
setmetatable(db, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function db:new(type, host, username, password, options)
    self.type = type or self.type
    self.host = host or self.host
    self.username = username or self.username
    self.password = password or self.password
    self.options = options or self.options
    self.dbHandle = dbConnect(self.type, self.host, self.username, self.password, self.options)
    assert(self.dbHandle, "Could not connect to database")
end

function db:query(query, ...)
    local qh = dbQuery(self.dbHandle, query, unpack(arg))
    return qh and dbPoll(qh, -1)
end

function db:exec(query, ...)
    return dbExec(self.dbHandle, query, unpack(arg))
end

function db:clone()
    return db:new(self.type, self.host, self.username, self.password, self.options)
end

DB = db
