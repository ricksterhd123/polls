-- Initialize views and addEventHandlers
local cursorShowing = false
local adminViewsShowing = false
local pollMain = nil
local pollEdit = nil
local pollVote = nil

function showAdminViews()
    -- TODO: find a way to encapsulate event handlers
    pollEdit = PollEdit()
    -- Add
    addEventHandler("onClientGUIClick", pollMain.button[1], 
    function ()
        iprint("Add")
        pollEdit:setMode(false)
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
    
    addEventHandler("onClientGUIClick", pollEdit.button[1],
    function ()
        if pollEdit.mode then -- edit
            local pollID = pollEdit:getPollID()
            if pollID then
                local title, description = pollEdit:getTitleDescription()
                triggerServerEvent("onPollChanged", localPlayer, pollID, title, description)
                iprint("edited")
                pollEdit:clear()
                pollEdit:setVisible(false)
            end
        else -- create
            iprint("Creating poll...")
            local title, description = pollEdit:getTitleDescription()
            triggerServerEvent("onPollCreated", localPlayer, title, description)
            pollEdit:clear()
            pollEdit:setVisible(false)
        end
    end, false)
    -- Back
    addEventHandler("onClientGUIClick", pollEdit.button[2],
    function ()
        pollEdit:clear()
        pollEdit:setVisible(false)
    end, false)
    adminViewsShowing = true
end


-- Retreives data from models, updates view.
function main(isAdmin, polls)
    if pollMain and pollMain.visible then return false end
    pollMain = PollMain(isAdmin, polls)
    pollMain:setVisible(true)

    if isAdmin then
        showAdminViews()
    end

    -- Read / vote poll
    addEventHandler("onClientGUIDoubleClick", pollMain.gridlist[1], 
    function()
        iprint("Read")
        local pollSelected = pollMain:getPollSelected()
        if not pollSelected then return false end
        pollVote = PollVote(pollSelected)
        pollVote:setVisible(true)

        -- note: when pollVote destroyed, assume event handler is also.
        -- Back
        addEventHandler("onClientGUIClick", pollVote.button[3],
        function()
            pollVote:destroy()
            pollVote = nil
        end, false)
    end, false)

    -- Update view
    addEvent("onClientUpdate", true)
    addEventHandler("onClientUpdate", resourceRoot, function(isAdmin, polls)
        pollMain:setAdmin(isAdmin)
        pollMain:setPolls(polls)
        if not isAdminViewsShowing and isAdmin then
            showAdminViews()
        end
    end)

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
        adminViewsShowing = false
        triggerServerEvent("onStop", localPlayer)
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