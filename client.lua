-- Retreives data from models, updates view.
function main(isAdmin, polls)
    local pollMain = PollMain(isAdmin, polls)
    pollMain:show()
    --local pollRead = PollRead()
    --local pollVote = PollVote()
    --local pollEdit = PollEdit()
    iprint(isAdmin)
end
addEvent("onStart", true)
addEventHandler("onStart", resourceRoot, main)

-- Get isAdmin from server
addEventHandler("onClientResourceStart", resourceRoot, 
    function() 
        triggerServerEvent("onPreStart", localPlayer) 
    end
)