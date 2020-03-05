-- Initialize views and addEventHandlers
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

    -- Check if player is admin before handling onClientGUIClick for buttons 1 - 4
    -- 1. Add     => Admin only
    -- 2. Edit    => Admin only
    -- 3. Archive => Admin only
    -- 4. Delete  => Admin only

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

        addEventHandler("onClientGUIClick", pollEdit.button[2],
        function ()
            pollEdit:clear()
            pollEdit:setVisible(false)
        end, false)
    end

    -- Read / vote poll
    addEventHandler("onClientGUIDoubleClick", pollMain.gridlist[1], 
    function()
        iprint("Read")
        local pollSelected = pollMain:getPollSelected()
        if not pollSelected then return false end
        pollVote = PollVote(pollSelected)
        pollVote:setVisible(true)

        addEventHandler("onClientGUIClick", pollVote.button[3],
        function()
            pollVote:destroy()
            pollVote = nil
        end, false)
    end, false)

    -- Close pollMain, pollEdit and pollVote views.
    -- Hide cursor if cursorShowing.
    addEventHandler("onClientGUIClick", pollMain.button[5], 
    function()
        pollMain:destroy()
        pollMain = nil
        
        if pollEdit then
            pollEdit:destroy()
            pollEdit = nil
        end
        if pollVote then
            pollVote:destroy()
            pollVote = nil
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

-- Get data from server before opening PollMain
addCommandHandler("polls", 
    function() 
        triggerServerEvent("onPreStart", localPlayer) 
    end
)

-- Hide cursor if resource stops and cursorShowing.
addEventHandler("onClientResourceStop", resourceRoot, 
    function()
        if cursorShowing then
            showCursor(false)
        end
    end
)