local GUIEditor = {
    gridlist = {},
    window = {},
    button = {}
}
GUIEditor.window[1] = guiCreateWindow(0.06, 0.09, 0.88, 0.83, "Poll window", true)
guiWindowSetSizable(GUIEditor.window[1], false)

GUIEditor.gridlist[1] = guiCreateGridList(0.03, 0.06, 0.74, 0.92, true, GUIEditor.window[1])
guiGridListAddColumn(GUIEditor.gridlist[1], "Description", 0.5)
guiGridListAddColumn(GUIEditor.gridlist[1], "Votes (YES/NO)", 0.5)
guiGridListAddRow(GUIEditor.gridlist[1])
guiGridListSetItemText(GUIEditor.gridlist[1], 0, 1, "Make superman invincible", false, false)
guiGridListSetItemText(GUIEditor.gridlist[1], 0, 2, "100/200", false, false)
GUIEditor.button[1] = guiCreateButton(0.78, 0.07, 0.20, 0.07, "Add", true, GUIEditor.window[1])
GUIEditor.button[2] = guiCreateButton(0.78, 0.16, 0.20, 0.07, "Edit", true, GUIEditor.window[1])
GUIEditor.button[3] = guiCreateButton(0.78, 0.25, 0.20, 0.07, "Archive", true, GUIEditor.window[1])
GUIEditor.button[4] = guiCreateButton(0.78, 0.34, 0.20, 0.07, "Delete", true, GUIEditor.window[1])