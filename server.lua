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
    -- iprint(polls:add("hello world", "12345test"))
    -- iprint(polls:get())
    -- iprint(votes:add(1, "pilot", 1))
    -- iprint(votes:get(1))
    -- Hook events:
end

addEventHandler("onResourceStart", resourceRoot, main)

function getPlayerAccountName(player)
    local account = getPlayerAccount(player)
    if not isGuestAccount(account) then
        return getAccountName(account)
    end
    return false
end

function getPollsAndVotes(player)
    local _polls = polls:get()

    -- Add votes to each poll
    for i, poll in ipairs(_polls) do
        local pollVotes = votes:get(poll.ID)
        local yPollVotes = 0            -- Yes votes
        local nPollVotes = #pollVotes   -- No votes
        local playerVoted = false       -- Has player voted on this poll yet?

        for i, vote in ipairs(pollVotes) do
            if vote.Vote == 1 then
                yPollVotes = yPollVotes + 1
                nPollVotes = nPollVotes - 1
            end
            if vote.Account == getPlayerAccountName(player) then
                playerVoted = true
            end
        end

        poll.VotesYes = yPollVotes
        poll.VotesNo  = nPollVotes
        poll.PlayerVoted = playerVoted
    end
    return _polls
end

function clientPreStart()
    local isAdmin = hasObjectPermissionTo(source, "function.kickPlayer", false)
    triggerClientEvent(source, "onStart", resourceRoot, isAdmin, getPollsAndVotes(source)) 
end
addEvent("onPreStart", true)
addEventHandler("onPreStart", root, clientPreStart)