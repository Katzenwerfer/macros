#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ..\modules\qpc.ahk

; ---------------------
; === Configuration ===
; ---------------------

; Timings in milliseconds
ClickDownTime := 2980

; ------------------------
; === Global variables ===
; ------------------------

CDTCounts := QPC.MsToCounts(ClickDownTime)

isEnabled := false
isCharging := false

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

#HotIf WinActive("ahk_exe helldivers2.exe")

; Hotkey to toggle macro
F1:: {
    global isEnabled, isCharging

    isEnabled := !isEnabled
    isCharging := false

    if !(isEnabled) {
        Click("Up")
    }

    ToolTip(isEnabled ? "Macro enabled" : "Macro disabled", 0, 0)
    SetTimer(() => ToolTip(), -2000)
}

#HotIf WinActive("ahk_exe helldivers2.exe") AND isEnabled

LButton:: {
    global isCharging

    isCharging := true

    Click("Down")

    target := QPC.Query() + CDTCounts

    while (QPC.Query() < target AND isCharging) {
        Sleep(-1)
    }

    Click("Up")
}

LButton Up:: {
    global isCharging
    isCharging := false
    Click("Up")
}
