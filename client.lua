local cursorShowing = false
local pollMain = nil
local pollEdit = nil
local pollVote = nil

-- Retreives data from models, updates view.
function main(isAdmin, polls)
    pollMain = PollMain(isAdmin, polls)
    -- pollVote = PollVote()
    
    pollMain:setVisible(true)
    if isAdmin then
        pollEdit = PollEdit()
        pollEdit:setMode(true)
        -- Add
        addEventHandler("onClientGUIClick", pollMain.button[1], 
        function ()
            iprint("Add")
            pollEdit:setMode(false)
            pollEdit:setTitle("")
            pollEdit:setDescription("")
            pollEdit:setVisible(true)
        end, false)
        -- Edit
        addEventHandler("onClientGUIClick", pollMain.button[2], 
        function ()
            iprint("Edit")
            pollEdit:setMode(true)
            pollEdit:setTitle("")
            pollEdit:setDescription("")
            pollEdit:setVisible(true)
        end, false)
        -- Archive
        addEventHandler("onClientGUIClick", pollMain.button[3], 
        function ()
            iprint("Archive")
        end, false)
        -- Delete
        addEventHandler("onClientGUIClick", pollMain.button[4], 
        function ()
            iprint("Delete")
        end, false)
    end

    
    

    -- Read
    addEventHandler("onClientGUIDoubleClick", pollMain.gridlist[1], 
    function()
        iprint("Read")
    end, false)

    showCursor(true)
    cursorShowing = true
end
addEvent("onStart", true)
addEventHandler("onStart", resourceRoot, main)

-- Get data from server
addCommandHandler("polls", 
    function() 
        triggerServerEvent("onPreStart", localPlayer) 
    end
)

addEventHandler("onClientResourceStop", resourceRoot, 
    function()
        if cursorShowing then
            showCursor(false)
        end
    end
)