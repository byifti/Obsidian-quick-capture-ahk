#Requires AutoHotkey v2.0
#SingleInstance Force

; Cabin Dusk palette
; BG: #161c22 
; Surface: #1c2430  
; Border/accent: #2a5068 
; Primary text: #e8e0d4 
; Dim text: #7ab4c8 
; Accent: #d4782e 
; Input bg: #0f1318 

!+q:: {
    g := Gui("+AlwaysOnTop -Caption +Border", "Quick Capture")
    g.BackColor := "161c22"
    g.MarginX := 16
    g.MarginY := 16

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w280 h2 Background2a5068", "")

    g.SetFont("s10 cd4782e bold", "Comic Relief")
    g.AddText("w280 y+10 Center", "⚡ Quick Capture")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w280 y+8 h1 Background2a5068 Center", "")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w280 y+10", "NOTE NAME")

    nameBox := g.AddEdit("w280 y+4 Background0f1318 -E0x200", "")
    nameBox.SetFont("s9 ce8e0d4", "Comic Relief")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w280 y+10", "CONTENT")

    contentBox := g.AddEdit("w280 r6 y+4 Background0f1318 Multi -E0x200", "")
    contentBox.SetFont("s9 ce8e0d4", "Comic Relief")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w280 y+8 h1 Background2a5068", "")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w280 y+4 Center", "Enter — Create  ·  Shift+Enter — New line  ·  Esc — Cancel")

    btnCreate := g.AddButton("w136 y+8 Background1c2430 -E0x200", "CREATE")
    btnCreate.SetFont("s8 cd4782e bold", "Comic Relief")
    btnCancel := g.AddButton("x+8 w136 Background1c2430 -E0x200", "CANCEL")
    btnCancel.SetFont("s8 c7ab4c8", "Comic Relief")

    btnCreate.OnEvent("Click", (*) => CreateNote(g, nameBox, contentBox))
    btnCancel.OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Close", (*) => g.Destroy())

    HotIfWinActive "ahk_id " g.Hwnd
    Hotkey "Escape", (*) => g.Destroy()
    Hotkey "Enter", (*) => HandleEnter(g, nameBox, contentBox)
    Hotkey "+Enter", (*) => (contentBox.Focus(), ControlSend("{Enter}", contentBox, g))
    HotIfWinActive "ahk_id 0"

    g.Show("w312 AutoSize")
    WinActivate "ahk_id " g.Hwnd
    nameBox.Focus()
}

HandleEnter(g, nameBox, contentBox) {
    focused := ControlGetFocus("ahk_id " g.Hwnd)
    if (focused = nameBox.Hwnd) {
        contentBox.Focus()
    } else {
        CreateNote(g, nameBox, contentBox)
    }
}

CreateNote(g, nameBox, contentBox) {
    name := Trim(nameBox.Value)
    content := contentBox.Value

    if (name = "") {
        MsgBox "Please enter a note name.", "Quick Capture", 48
        return
    }

    name := RegExReplace(name, '[\\/:*?"<>|]', "")
    path := A_Desktop "\" name ".md"

    FileOpen(path, "w").Write(content)
    g.Destroy()
}