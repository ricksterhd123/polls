local cursorShowing = false
local pollMain = nil
local pollEdit = nil
local pollVote = nil

-- Retreives data from models, updates view.
function main(isAdmin, polls)
    if pollMain and pollMain.visible then return false end
    pollMain = PollMain(isAdmin, polls)
    -- pollVote = PollVote()
    
    pollMain:setVisible(true)
    if isAdmin then
        pollEdit = PollEdit()
        -- Add
        addEventHandler("onClientGUIClick", pollMain.button[1], 
        function ()
            iprint("Add")
            pollEdit:setMode(false)
            pollEdit:clear()
            pollEdit:setVisible(true)
        end, false)

        -- Edit
        addEventHandler("onClientGUIClick", pollMain.button[2], 
        function ()
            iprint("Edit")
            local pollSelected = pollMain:getPollSelected()
            if not pollSelected then return false end
            pollEdit:setMode(true)
            pollEdit:setPoll(pollSelected)
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

    -- Close pollMain
    addEventHandler("onClientGUIClick", pollMain.button[5], 
    function()
        pollMain:destroy()
        pollMain = nil
        if pollEdit then
            pollEdit:destroy()
            pollEdit = nil
        end

        if cursorShowing then
            showCursor(false)
            cursorShowing = false
        end
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