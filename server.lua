-- Receives input, gives it to the controller then manipulate model 
-- and send it to the view on each client
local dbType = "sqlite"
local dbFileName = "poll.db"


local db = nil
local polls = nil
local votes = nil
local controller = nil
local players = nil

function main()
    -- create database handle
    db = DB("sqlite", "polls.db")
    iprint(db.dbHandle)
    -- initialize models
    -- Polls
    polls = Polls(db)
    -- Votes
    votes = Votes(db)
    -- Controller
    controller = Controller(polls, votes)
    players = {}
    -- iprint(polls:add("hello world", "12345test"))
    -- iprint(polls:get())
    -- iprint(votes:add(1, "pilot", 1))
    -- iprint(votes:get(1))
    -- Hook events:


    addEvent("onPreStart", true)
    addEventHandler("onPreStart", root, function ()
        if source then
            local isAdmin = controller:isPlayerAdmin(source)
            local pollsAndVotes = controller:getPollsAndVotes(source)
            triggerClientEvent(source, "onStart", resourceRoot, isAdmin, pollsAndVotes) 
            table.insert(players, source)
        end
    end)

    addEvent("onStop", true)
    addEventHandler("onStop", root, function ()
        for i, v in ipairs(players) do
            if source == v then
                return table.remove(players, i)
            end
        end
    end)

    addEvent("onPollVoted", true)
    addEventHandler("onPollVoted", root, function (pollID, votedYes)
        local accName = controller:getPlayerAccountName(source)
        if accName then
            controller:onPollVoted(pollID, accName, votedYes)
            -- Trigger update using pollID
        end
    end)

    addEvent("onPollCreated", true)
    addEventHandler("onPollCreated", root, function (title, description)
        local isAdmin = controller:isPlayerAdmin(source)
        if isAdmin then
            controller:onPollCreated(title, description)
            -- Trigger update
            -- TODO: Give updated poll instead of a complete reset
            for i, v in ipairs(players) do
                triggerClientEvent(v, "onClientUpdate", resourceRoot, controller:isPlayerAdmin(v), controller:getPollsAndVotes(v))
            end
        end
    end)

    addEvent("onPollChanged", true)
    addEventHandler("onPollChanged", root, function (pollID, newTitle, newDescription)
        local isAdmin = controller:isPlayerAdmin(source)
        if isAdmin then
            controller:onPollChanged(pollID, newTitle, newDescription)
            iprint("changed")
            -- Trigger update
            -- TODO: Give updated poll instead of a complete reset
            for i, v in ipairs(players) do
                triggerClientEvent(v, "onClientUpdate", resourceRoot, controller:isPlayerAdmin(v), controller:getPollsAndVotes(v))
            end
        end
    end)

    addEvent("onPollArchived", true)
    addEventHandler("onPollArchived", root, function (pollID)
    end)

    addEvent("onPollDeleted", true)
    addEventHandler("onPollDeleted", root, function (pollID)
    end)
end

addEventHandler("onResourceStart", resourceRoot, main)
