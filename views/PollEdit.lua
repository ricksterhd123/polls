local GUIEditor = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}
GUIEditor.window[1] = guiCreateWindow(0.32, 0.20, 0.36, 0.60, "Create poll", true)
guiWindowSetSizable(GUIEditor.window[1], false)

GUIEditor.memo[1] = guiCreateMemo(0.03, 0.28, 0.93, 0.57, "", true, GUIEditor.window[1])
GUIEditor.edit[1] = guiCreateEdit(0.03, 0.14, 0.88, 0.07, "", true, GUIEditor.window[1])
GUIEditor.label[1] = guiCreateLabel(0.03, 0.08, 0.88, 0.06, "Title:", true, GUIEditor.window[1])
guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
GUIEditor.label[2] = guiCreateLabel(0.03, 0.22, 0.88, 0.06, "Description:", true, GUIEditor.window[1])
guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
GUIEditor.button[1] = guiCreateButton(0.04, 0.89, 0.33, 0.09, "Create Poll", true, GUIEditor.window[1])
GUIEditor.button[2] = guiCreateButton(0.40, 0.89, 0.33, 0.09, "Back", true, GUIEditor.window[1])