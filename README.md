# Obsidian Quick Capture AHK Script

This is an AutoHotKey script that allows user to write a ".md" file on a specific location. Mainly intended to use as lightweight Obsidian Quick Capture


# Features

- Small window popup when Hotkey is pressed that includes: Note's name/title, Note's content and keybindings tip
- Lightweight and minimal
- Does not need to open Obsidian app at all
- Lives in your system tray 
- Untitled notes automatically get timestamped title (Hour:Min DD-MM-YY Format)


# Dependencies
- [AutoHotkey v2.0](https://www.autohotkey.com/)


# Installation

1) Download the ObsidianQuickCapture.ahk file from my repo
2) Download dependencies ([AutoHotkey v2.0](https://www.autohotkey.com/))
3) Press windows + r
4) Type shell:startup and enter 
5) Put the ObsidianQuickCapture.ahk in that folder *(So that it turns on in startup)*
6) Configure it by following the steps below
7) Click it *(You only need to click it for the first time. If it doesn't work then try reloading the script from your system tray)*



# Configuration 
### Hotkey Setup

By default the hotkey is set to `Alt+Shift+Q`. To change it, go to ObsidianQuickCapture.ahk and open it in your code editor and just replace 

```
!+q
```

with whatever hotkey you want. Check out [list of hotkeys](https://www.autohotkey.com/docs/v2/KeyList.htm) for reference

### Vault Setup

By default the `.md` file is saved at `C:\Users\<YourUsername>\Desktop`. Change the 

```
path := A_Desktop
```

to your vault's path. eg.
```
path := "D:\Obsidian Vaults\Yggdrasil\" name ".md"
```

Now it should work perfectly! Press your hotkey to check it out! 🔥

