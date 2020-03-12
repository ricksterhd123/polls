

-- Takes input, updates model
local controller = {}
controller.__index = controller

setmetatable(controller, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function controller:new(polls, votes)
    assert(polls and votes)
    self.polls = polls
    self.votes = votes
end

function controller:isPlayerAdmin(player)
    return hasObjectPermissionTo(player, "function.kickPlayer", false)
end


function controller:getPlayerAccountName(player)
    local account = getPlayerAccount(player)
    if not isGuestAccount(account) then
        return getAccountName(account)
    end
    return false
end

function controller:getPollsAndVotes(player)
    local _polls = self.polls:get()
    -- Add votes to each poll
    for _, poll in ipairs(_polls) do
        local pollVotes = self.votes:get(poll.ID)
        local yPollVotes = 0            -- Yes votes
        local nPollVotes = #pollVotes   -- No votes
        local playerVoted = false       -- Has player voted on this poll yet?
        for _, vote in ipairs(pollVotes) do
            if vote.Vote == 1 then
                yPollVotes = yPollVotes + 1
                nPollVotes = nPollVotes - 1
            end
            if vote.Account == self:getPlayerAccountName(player) then
                playerVoted = true
            end
        end
        poll.VotesYes = yPollVotes
        poll.VotesNo  = nPollVotes
        poll.PlayerVoted = playerVoted
    end
    return _polls
end

-- Add poll
function controller:onPollVoted(pollID, accountName, votedYes)
    return self.votes:add(pollID, accountName, votedYes)
end

function controller:onPollCreated(title, description)
    return self.polls:add(title, description)
end

function controller:onPollChanged(pollID, newTitle, newDescription, archived)
    return self.polls:update(pollID, newTitle, newDescription, archived)
end

function controller:onPollArchived(pollID)
    -- TODO
end

function controller:onPollDeleted(pollID)
    -- TODO
end

Controller = controller