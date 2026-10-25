#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------
; === Global variables ===
; ------------------------

isEnabled := false
isShooting := false

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

#HotIf WinActive("ahk_exe th16.exe")

; Hotkey to toggle macro
F1:: {
    global isEnabled, isShooting

    isEnabled := !isEnabled
    isShooting := false

    if !(isEnabled) {
        Send("{j Up}")
    }

    ToolTip(isEnabled ? "Macro enabled" : "Macro disabled", 0, 0)
    SetTimer(() => ToolTip(), -2000)
}

#HotIf WinActive("ahk_exe th16.exe") AND isEnabled

; Hotkey to toggle holding down fire
*m:: {
    global isShooting

    isShooting := !isShooting

    if (isShooting) {
        Send("{j Down}")
        ToolTip("Fire on", 0, 0)
    }
    else {
        Send("{j Up}")
        ToolTip("Fire off", 0, 0)
    }

    SetTimer(() => ToolTip(), -2000)
}

~*j Up:: {
    global isShooting

    if (isShooting) {
        isShooting := false
        ToolTip("Fire off", 0, 0)
        SetTimer(() => ToolTip(), -2000)
    }
}
