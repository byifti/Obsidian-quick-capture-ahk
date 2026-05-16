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

; ─── Constants ───────────────────────────────────────────────
INI_DIR          := A_AppData "\ObsidianInstantCapture"
INI_FILE         := INI_DIR "\settings.ini"
DEFAULT_HK       := "!+q"
DEFAULT_HK_LABEL := "Alt + Shift + Q"

; ─── Bootstrap ───────────────────────────────────────────────
if !DirExist(INI_DIR)
    DirCreate(INI_DIR)

savedHk := IniRead(INI_FILE, "Settings", "Hotkey", DEFAULT_HK)
try
    Hotkey(savedHk, (*) => ShowCapture(), "On")
catch
    Hotkey(DEFAULT_HK, (*) => ShowCapture(), "On")

if (IniRead(INI_FILE, "Settings", "ReopenAfterReload", "0") = "1") {
    IniDelete(INI_FILE, "Settings", "ReopenAfterReload")
    ShowCapture()
}

; ─────────────────────────────────────────────────────────────
ShowSetup() {
    sg := Gui("+AlwaysOnTop -Caption +Border", "Instant Capture — Setup")
    sg.BackColor := "161c22"
    sg.MarginX := 24
    sg.MarginY := 24

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w320 h2 Background2a5068", "")

    sg.SetFont("s11 cd4782e bold", "Comic Relief")
    sg.AddText("w320 y+14 Center", "⚡ Instant Capture")

    sg.SetFont("s9 ce8e0d4", "Comic Relief")
    sg.AddText("w320 y+6 Center", "First time setup")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w320 y+10 h1 Background2a5068", "")

    sg.SetFont("s8 c7ab4c8", "Comic Relief")
    sg.AddText("w320 y+14", "VAULT FOLDER")

    pathBox := sg.AddEdit("w320 y+5 Background0f1318 -E0x200", "")
    pathBox.SetFont("s9 ce8e0d4", "Comic Relief")

    browseBtn := sg.AddButton("w320 y+6 Background1c2430 -E0x200", "Browse…")
    browseBtn.SetFont("s9 c7ab4c8", "Comic Relief")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w320 y+14 h1 Background2a5068", "")

    confirmBtn := sg.AddButton("w320 y+10 Background1c2430 -E0x200", "CONFIRM")
    confirmBtn.SetFont("s9 cd4782e bold", "Comic Relief")

    browseBtn.OnEvent("Click", (*) => BrowseFolder(pathBox, sg))
    confirmBtn.OnEvent("Click", (*) => SaveSetup(sg, pathBox))
    sg.OnEvent("Close", (*) => sg.Destroy())

    HotIfWinActive "ahk_id " sg.Hwnd
    Hotkey "Escape", (*) => sg.Destroy()
    Hotkey "*Enter", (*) => SaveSetup(sg, pathBox)
    HotIfWinActive

    sg.Show("w368 AutoSize")
    RoundCorners(sg.Hwnd)
}

; ─────────────────────────────────────────────────────────────
BrowseFolder(pathBox, ownerGui, parentGui := 0) {
    ownerGui.Hide()
    if (parentGui != 0)
        parentGui.Hide()
    chosen := DirSelect("*" pathBox.Value, 3, "Select your Obsidian vault folder")
    ownerGui.Show()
    if (parentGui != 0)
        parentGui.Show()
    WinActivate "ahk_id " ownerGui.Hwnd
    if (chosen != "")
        pathBox.Value := chosen
}

; ─────────────────────────────────────────────────────────────
SaveSetup(sg, pathBox) {
    path := Trim(pathBox.Value)
    if (path = "" || !DirExist(path)) {
        MsgBox "Please select a valid folder.", "Instant Capture", 48
        return
    }
    IniWrite(path, INI_FILE, "Settings", "VaultPath")
    sg.Destroy()
    ShowCapture()
}

; ─────────────────────────────────────────────────────────────
ShowCapture() {
    vaultPath := IniRead(INI_FILE, "Settings", "VaultPath", "")
    if (vaultPath = "") {
        ShowSetup()
        return
    }

    g := Gui("+AlwaysOnTop -Caption +Border", "Instant Capture")
    g.BackColor := "161c22"
    g.MarginX := 20
    g.MarginY := 20

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 h2 Background2a5068", "")

    g.SetFont("s11 cd4782e bold", "Comic Relief")
    g.AddText("w320 y+12", "⚡ Instant Capture")

    gearBtn := g.AddText("x+0 w40 y+12 Right c2a5068 Background161c22", "⚙")
    gearBtn.SetFont("s12", "Comic Relief")
    gearBtn.OnEvent("Click", (*) => ShowSettings(g))

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 xm y+8 h1 Background2a5068", "")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w360 y+12", "NOTE NAME")
    nameBox := g.AddEdit("w360 y+5 Background0f1318 -E0x200", "")
    nameBox.SetFont("s10 ce8e0d4", "Comic Relief")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w360 y+12", "CONTENT")
    contentBox := g.AddEdit("w360 r8 y+5 Background0f1318 Multi -E0x200", "")
    contentBox.SetFont("s10 ce8e0d4", "Comic Relief")

    g.SetFont("s8 c7ab4c8", "Comic Relief")
    g.AddText("w360 y+12", "TAGS  (optional)")
    tagBox := g.AddEdit("w360 r2 y+5 Background0f1318 Multi -E0x200", "")
    tagBox.SetFont("s10 ce8e0d4", "Comic Relief")

    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 y+10 h1 Background2a5068", "")
    g.SetFont("s7 c2a5068", "Comic Relief")
    g.AddText("w360 y+6 Center", "Enter — Create  ·  Shift+Enter — New line  ·  Tab — Tags  ·  Esc — Cancel")

    errLabel := g.AddText("w360 y+6 cFF4444 Center", "")
    errLabel.SetFont("s8", "Comic Relief")

    btnCreate := g.AddButton("w176 y+6 Background1c2430 -E0x200", "CREATE")
    btnCreate.SetFont("s9 cd4782e bold", "Comic Relief")
    btnCancel := g.AddButton("x+8 w176 Background1c2430 -E0x200", "CANCEL")
    btnCancel.SetFont("s9 c7ab4c8", "Comic Relief")

    s := {g: g, nameBox: nameBox, contentBox: contentBox, tagBox: tagBox, vaultPath: vaultPath, errLabel: errLabel}

    btnCreate.OnEvent("Click", (*) => CreateNote(s))
    btnCancel.OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Close", (*) => g.Destroy())

    HotIfWinActive "ahk_id " g.Hwnd
    Hotkey "Escape",     (*) => g.Destroy()
    Hotkey "^Backspace", (*) => Send("^+{Left}{Backspace}")
    Hotkey "*Enter",     OnEnter.Bind(s)
    Hotkey "Tab",        OnTab.Bind(s)
    Hotkey "*Space",     OnSpace.Bind(s)
    HotIfWinActive

    g.Show("w400 AutoSize")
    WinActivate "ahk_id " g.Hwnd
    nameBox.Focus()
    RoundCorners(g.Hwnd)
}

; ─────────────────────────────────────────────────────────────
ShowSettings(parentGui) {
    sg := Gui("+AlwaysOnTop -Caption +Border +Owner" parentGui.Hwnd, "Settings")
    sg.BackColor := "161c22"
    sg.MarginX := 20
    sg.MarginY := 20

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w280 h2 Background2a5068", "")

    sg.SetFont("s10 cd4782e bold", "Comic Relief")
    sg.AddText("w280 y+12 Center", "⚙ Settings")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w280 y+10 h1 Background2a5068", "")

    sg.SetFont("s8 c7ab4c8", "Comic Relief")
    sg.AddText("w280 y+12", "VAULT FOLDER")

    currentPath := IniRead(INI_FILE, "Settings", "VaultPath", "")
    pathBox := sg.AddEdit("w280 y+5 Background0f1318 -E0x200", currentPath)
    pathBox.SetFont("s8 ce8e0d4", "Comic Relief")

    browseBtn := sg.AddButton("w280 y+6 Background1c2430 -E0x200", "Browse…")
    browseBtn.SetFont("s9 c7ab4c8", "Comic Relief")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w280 y+14 h1 Background2a5068", "")

    sg.SetFont("s8 c7ab4c8", "Comic Relief")
    sg.AddText("w280 y+12", "HOTKEY")

    currentLabel := IniRead(INI_FILE, "Settings", "HotkeyLabel", DEFAULT_HK_LABEL)
    hkLabel := sg.AddText("w280 h22 y+5 ce8e0d4", currentLabel)
    hkLabel.SetFont("s10 bold", "Comic Relief")

    changeHkBtn := sg.AddButton("w280 y+6 Background1c2430 -E0x200", "Change Hotkey")
    changeHkBtn.SetFont("s9 c7ab4c8", "Comic Relief")

    hkError := sg.AddText("w280 y+4 cFF4444", "")
    hkError.SetFont("s8", "Comic Relief")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w280 y+6", "Tip: Stick to Alt+Shift+Letter combos. Avoid Win+L,`nCtrl+Alt+anything, or Ctrl+Shift+Letter — these`noften conflict with system or app shortcuts.")

    sg.SetFont("s7 c2a5068", "Comic Relief")
    sg.AddText("w280 y+14 h1 Background2a5068", "")

    saveBtn := sg.AddButton("w136 y+10 Background1c2430 -E0x200", "SAVE")
    saveBtn.SetFont("s9 cd4782e bold", "Comic Relief")
    cancelBtn := sg.AddButton("x+8 w136 Background1c2430 -E0x200", "CANCEL")
    cancelBtn.SetFont("s9 c7ab4c8", "Comic Relief")

    pendingHk := {str: "", label: ""}

    browseBtn.OnEvent("Click", (*) => BrowseFolder(pathBox, sg, parentGui))
    changeHkBtn.OnEvent("Click", (*) => RecordHotkey(changeHkBtn, hkLabel, hkError, pendingHk))
    saveBtn.OnEvent("Click", (*) => SaveSettings(sg, pathBox, pendingHk, parentGui))
    cancelBtn.OnEvent("Click", (*) => sg.Destroy())
    sg.OnEvent("Close", (*) => sg.Destroy())

    HotIfWinActive "ahk_id " sg.Hwnd
    Hotkey "Escape", (*) => sg.Destroy()
    Hotkey "*Enter", (*) => SaveSettings(sg, pathBox, pendingHk, parentGui)
    HotIfWinActive

    parentGui.GetPos(&px, &py, &pw)
    sg.Show("x" (px + pw + 8) " y" py " w320 AutoSize")
    RoundCorners(sg.Hwnd)
    SendMessage(0x00B1, 0, 0, pathBox)
}

; ─────────────────────────────────────────────────────────────
RecordHotkey(btn, hkLabel, hkError, pendingHk) {
    btn.Text := "Press your combo…"
    hkError.Text := ""
    ih := InputHook("L1 T5")
    ih.KeyOpt("{All}", "S")
    ih.Start()

    deadline := A_TickCount + 5000
    captured := false
    loop {
        if (A_TickCount > deadline)
            break
        modVKs := [0x10,0x11,0x12,0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0x5B,0x5C]
        loop 254 {
            vk := A_Index
            ismod := false
            for m in modVKs
                if (vk = m) {
                    ismod := true
                    break
                }
            if ismod
                continue
            if !GetKeyState(Format("vk{:x}", vk), "P")
                continue

            mods := "", label := ""
            if GetKeyState("LWin","P")||GetKeyState("RWin","P")
                mods .= "#", label .= "Win + "
            if GetKeyState("LCtrl","P")||GetKeyState("RCtrl","P")
                mods .= "^", label .= "Ctrl + "
            if GetKeyState("LAlt","P")||GetKeyState("RAlt","P")
                mods .= "!", label .= "Alt + "
            if GetKeyState("LShift","P")||GetKeyState("RShift","P")
                mods .= "+", label .= "Shift + "

            keyName   := GetKeyName(Format("vk{:x}", vk))
            hkStr     := mods . keyName
            hkDisplay := label . StrUpper(keyName)

            ih.Stop()
            captured := true

            if (mods = "") {
                hkError.Text := "Include at least one modifier (Alt, Ctrl, Shift, Win)."
                break 2
            }
            pendingHk.str   := hkStr
            pendingHk.label := hkDisplay
            hkLabel.Text    := hkDisplay
            hkError.Text    := ""
            break 2
        }
        Sleep(30)
    }

    ih.Stop()
    btn.Text := "Change Hotkey"
    if (!captured && hkError.Text = "")
        hkError.Text := "No key detected — try again."
}

; ─────────────────────────────────────────────────────────────
SaveSettings(sg, pathBox, pendingHk, parentGui) {
    path := Trim(pathBox.Value)
    if (path = "" || !DirExist(path)) {
        MsgBox "Please select a valid folder.", "Instant Capture", 48
        return
    }
    IniWrite(path, INI_FILE, "Settings", "VaultPath")

    if (pendingHk.str != "") {
        IniWrite(pendingHk.str,   INI_FILE, "Settings", "Hotkey")
        IniWrite(pendingHk.label, INI_FILE, "Settings", "HotkeyLabel")
    }

    IniWrite("1", INI_FILE, "Settings", "ReopenAfterReload")
    parentGui.Destroy()
    sg.Destroy()
    Reload()
}

; ─────────────────────────────────────────────────────────────
RoundCorners(hwnd) {
    cornerPref := 3
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "UInt*", cornerPref, "UInt", 4)
}

; ─────────────────────────────────────────────────────────────
OnTab(s, *) {
    focused := ControlGetFocus("ahk_id " s.g.Hwnd)
    if (focused = s.nameBox.Hwnd) {
        s.contentBox.Focus()
        SendMessage(0x00B1, 0, 0, s.contentBox)
    } else if (focused = s.contentBox.Hwnd) {
        s.tagBox.Focus()
        ; Move caret to end
        len := StrLen(s.tagBox.Value)
        SendMessage(0x00B1, len, len, s.tagBox)
    } else {
        ; Tab from tag box or anywhere else — do nothing, stay put
    }
}

OnSpace(s, *) {
    focused := ControlGetFocus("ahk_id " s.g.Hwnd)
    if (focused != s.tagBox.Hwnd) {
        Send("{Space}")
        return
    }
    ; Get caret position and current value
    sel  := SendMessage(0x00B0, 0, 0, s.tagBox)
    pos  := sel & 0xFFFF
    val  := s.tagBox.Value

    ; Find the current word being typed (from last space to caret)
    start := 0
    loop pos {
        if (SubStr(val, A_Index, 1) = " ")
            start := A_Index
    }
    word := Trim(SubStr(val, start + 1, pos - start))
    word := RegExReplace(word, "[^a-zA-Z0-9_\-]", "")

    if (word = "") {
        ; Nothing to confirm — eat the space
        return
    }

    ; Replace the raw word with #word + space
    before := SubStr(val, 1, start)
    after  := SubStr(val, pos + 1)
    ; Strip any existing # the user may have typed
    word   := LTrim(word, "#")
    newVal := before . "#" . word . " " . after
    s.tagBox.Value := newVal
    newPos := StrLen(before) + StrLen(word) + 2  ; after "#word "
    SendMessage(0x00B1, newPos, newPos, s.tagBox)
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
    } else if (focused = s.contentBox.Hwnd || focused = s.tagBox.Hwnd) {
        CreateNote(s)
    }
}

; ─────────────────────────────────────────────────────────────
; Parse tag box value into a clean list of tag strings
ParseTags(tagBox) {
    raw  := tagBox.Value
    tags := []
    loop parse, raw, " ", "`t`r`n" {
        word := Trim(A_LoopField)
        if (word = "")
            continue
        word := LTrim(word, "#")
        word := RegExReplace(word, "[^a-zA-Z0-9_\-]", "")
        if (word != "")
            tags.Push(word)
    }
    return tags
}

; ─────────────────────────────────────────────────────────────
CreateNote(s) {
    name    := Trim(s.nameBox.Value)
    content := s.contentBox.Value
    tags    := ParseTags(s.tagBox)

    if (name = "")
        name := FormatTime(, "HH-mm dd-MM-yyyy")

    name := RegExReplace(name, '[\\/:*?"<>|]', "")
    path := s.vaultPath "\" name ".md"

    ; Build file content — prepend YAML only if tags exist
    fileContent := ""
    if (tags.Length > 0) {
        fileContent := "---`ntags:`n"
        for t in tags
            fileContent .= "  - " . t . "`n"
        fileContent .= "---`n"
        if (content != "")
            fileContent .= "`n"
    }
    fileContent .= content

    try {
        FileOpen(path, "w").Write(fileContent)
        s.g.Destroy()
    } catch {
        fallbackPath := A_Desktop "\" name ".md"
        try {
            FileOpen(fallbackPath, "w").Write(fileContent)
            s.errLabel.Text := "Vault unreachable — note saved to Desktop instead."
        } catch {
            s.errLabel.Text := "Could not save. Please check your vault path in Settings."
        }
    }
}
