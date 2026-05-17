# Obsidian Instant Capture

Instantly capture your thoughts, ideas and notes **even when Obsidian is closed**

**Hit a hotkey → Type → Save → Done**

No app switching. No launch required. Capture from anywhere without breaking your workflow

<img width="800" alt="Screenshot (4217)" src="https://github.com/user-attachments/assets/169bf549-c85d-43e0-abf3-5b7a74c80df5" />
<img width="800" alt="Screenshot (4218)" src="https://github.com/user-attachments/assets/7bb3776c-3a81-40d2-bb8b-a5bde41f1182" />

The tool directly saves note in ur obsidian vault

# Features

- Works without opening Obsidian
- Always lives in your system tray (low resource usage)
- Untitled notes automatically get timestamped title for fast workflow (Hour:Min DD-MM-YY Format)
- Set your Hotkey to whatever you like (The default is `Alt + Shift + Q`)
- Optional Properties tag support. Add tags directly to your note's Obsidian Properties (The keybind is `Tab` inside main GUI)

# Dependencies
- [AutoHotkey v2.0](https://www.autohotkey.com/)


# How To Set Up

1) Download the ObsidianInstantCapture.ahk file from releases
2) Download dependencies ([AutoHotkey v2.0](https://www.autohotkey.com/))
3) Press `Win + R`
4) Type shell:startup and enter 
5) Put the ObsidianInstantCapture.ahk in that folder *(So that it turns on in startup)*
6) Double-click the script to run it *(Only needed first time)*
7) Press `Alt + Shift + Q`, it'll ask for your vault folder path first time. Browse and select it.

Then the capture window will open automatically when the hotkey is pressed from now on

Done! You're ready to use it!

Note: If you want to change the hotkey to something else or change the file path then press the gear icon (Above Title) and it'll let you change the hotkey or file path

Also settings are saved to `%AppData%\ObsidianInstantCapture\settings.ini`, delete this file if you ever want to fully reset the configuration
