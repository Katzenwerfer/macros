#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ..\modules\qpc.ahk
#include ..\modules\wait.ahk

; ---------------------
; === Configuration ===
; ---------------------

; Timings in milliseconds
ClickDownTime := 1020
ClickUpTime := 20

; ------------------------
; === Global variables ===
; ------------------------

CDTCounts := QPC.MsToCounts(ClickDownTime)
CUTCounts := QPC.MsToCounts(ClickUpTime)

isEnabled := false
isShooting := false

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
    global isEnabled, isShooting

    isEnabled := !isEnabled
    isShooting := false

    if !(isEnabled) {
        Click("Up")
    }

    ToolTip(isEnabled ? "Macro enabled" : "Macro disabled", 0, 0)
    SetTimer(() => ToolTip(), -2000)
}

#HotIf WinActive("ahk_exe helldivers2.exe") AND isEnabled

LButton:: {
    global isShooting

    isShooting := true

    while (isShooting) {
        Click("Down")

        Wait(CDTCounts)

        Click("Up")

        Wait(CUTCounts)
    }
}

LButton Up:: {
    global isShooting
    isShooting := false
    Click("Up")
}
