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
    g.MarginX := 20
    g.MarginY := 20

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 h2 Background2a5068", "")

    g.SetFont("s11 cd4782e bold", "Comic Relief")
    g.AddText("w360 y+12 Center", "⚡ Quick Capture")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 y+10 h1 Background2a5068 Center", "")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w360 y+12", "NOTE NAME")
    nameBox := g.AddEdit("w360 y+5 Background0f1318 -E0x200", "")
    nameBox.SetFont("s10 ce8e0d4", "Comic Relief")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w360 y+12", "CONTENT")
    contentBox := g.AddEdit("w360 r8 y+5 Background0f1318 Multi -E0x200", "")
    contentBox.SetFont("s10 ce8e0d4", "Comic Relief")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 y+10 h1 Background2a5068", "")
    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 y+6 Center", "Enter — Create  ·  Shift+Enter — New line  ·  Esc — Cancel")

    btnCreate := g.AddButton("w176 y+10 Background1c2430 -E0x200", "CREATE")
    btnCreate.SetFont("s9 cd4782e bold", "Comic Relief")
    btnCancel := g.AddButton("x+8 w176 Background1c2430 -E0x200", "CANCEL")
    btnCancel.SetFont("s9 c7ab4c8", "Comic Relief")

    s := {g: g, nameBox: nameBox, contentBox: contentBox}

    btnCreate.OnEvent("Click", (*) => CreateNote(s))
    btnCancel.OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Close", (*) => g.Destroy())

    HotIfWinActive "ahk_id " g.Hwnd
    Hotkey "Escape",     (*) => g.Destroy()
    Hotkey "^Backspace", (*) => Send("^+{Left}{Backspace}")
    Hotkey "*Enter",     OnEnter.Bind(s)
    HotIfWinActive "ahk_id 0"

    g.Show("w400 AutoSize")
    WinActivate "ahk_id " g.Hwnd
    nameBox.Focus()

    cornerPref := 3
    DllCall("dwmapi\DwmSetWindowAttribute",
        "Ptr",  g.Hwnd,
        "UInt", 33,
        "UInt*", cornerPref,
        "UInt", 4)
}

OnEnter(s, *) {
    focused := ControlGetFocus("ahk_id " s.g.Hwnd)
    if GetKeyState("Shift", "P") {
        if (focused = s.contentBox.Hwnd)
            PostMessage(0x0102, 13, 0, s.contentBox)
        return
    }
    if (focused = s.nameBox.Hwnd) {
        s.contentBox.Focus()
        SendMessage(0x00B1, 0, 0, s.contentBox)
    } else if (focused = s.contentBox.Hwnd) {
        CreateNote(s)
    }
}

CreateNote(s) {
    name := Trim(s.nameBox.Value)
    content := s.contentBox.Value

    if (name = "")
        name := FormatTime(, "HH-mm dd-MM-yyyy")

    name := RegExReplace(name, '[\\/:*?"<>|]', "")
    path := A_Desktop "\" name ".md"

    FileOpen(path, "w").Write(content)
    s.g.Destroy()
}
