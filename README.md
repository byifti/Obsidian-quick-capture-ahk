# Obsidian Instant Capture

Instantly capture your thoughts, ideas and notes **even when Obsidian is closed**

**Hit a hotkey → Type → Save → Done**

No app switching. No launch required. Capture from anywhere without breaking your workflow

Built with [AutoHotkey](https://www.autohotkey.com/) for speed and simplicity, this tool writes directly to your vault so your notes are ready the next time you open Obsidian.

# Features

- Works without opening Obsidian
- Always lives in your system tray (low resource usage)
- Untitled notes automatically get timestamped title for fast workflow (Hour:Min DD-MM-YY Format)
- Set your Hotkey to whatever you like (The default is `Alt + Shift + Q`)

# Dependencies
- [AutoHotkey v2.0](https://www.autohotkey.com/)


# How To Set Up

1) Download the ObsidianInstantCapture.ahk file from my repo
2) Download dependencies ([AutoHotkey v2.0](https://www.autohotkey.com/))
3) Press `Win + R`
4) Type shell:startup and enter 
5) Put the ObsidianInstantCapture.ahk in that folder *(So that it turns on in startup)*
6) Double-click the script to run it *(Only needed first time)*
7) Press `Alt + Shift + Q`, it'll ask for your vault folder path first time. Browse and select it.

Then the capture window will open automatically when the hotkey is pressed from now on

Done! You're ready to use it!

Note: If you want to change the hotkey to something else or change the file path then press the gear icon (Above Title) and it'll let you change the hotkey or file path.

Also settings are saved to %AppData%\ObsidianInstantCapture\settings.ini — delete this file if you ever want to fully reset the configuration
