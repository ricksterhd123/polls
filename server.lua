-- Receives input, gives it to the controller then manipulate model 
-- and send it to the view on each client
local dbType = "sqlite"
local dbFileName = "poll.db"


local db = nil
local polls = nil
local votes = nil

function main()
    -- create database handle
    db = DB("sqlite", "polls.db")
    iprint(db.dbHandle)
    -- initialize models
    -- Polls
    polls = Polls(db)
    -- Votes
    votes = Votes(db)
    iprint(polls:add("hello world", "12345test"))
    iprint(polls:get())
    iprint(votes:add(1, "pilot", 1))
    iprint(votes:get(1))
    -- Hook events:
end

addEventHandler("onResourceStart", resourceRoot, main)