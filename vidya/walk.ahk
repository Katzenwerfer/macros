#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------
; === Global variables ===
; ------------------------

isEnabled := false
isAutoMoving := false

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

; Hotkey to toggle macro
#HotIf WinActive("ahk_exe helldivers2.exe")

F1:: {
    global isEnabled, isAutoMoving

    isEnabled := !isEnabled
    isAutoMoving := false

    ToolTip(isEnabled ? "Macro enabled" : "Macro disabled", 0, 0)
    SetTimer(() => ToolTip(), -2000)
}

; Limit macro activation to Helldivers 2 only
#HotIf WinActive("ahk_exe helldivers2.exe") AND isEnabled

; --- FORWARD KEY (W) ---
; ~ lets the game receive the original 'w' key press normally
~*w:: {
    global isAutoMoving

    ; If auto-move is currently active, tapping W cancels it
    if (isAutoMoving) {
        isAutoMoving := false
        Send("{Blind}{w up}")
        return
    }

    ; Detect double-tap: checks if the previous hotkey was ~*w within 300 ms
    if (A_PriorHotkey == "~*w" && A_TimeSincePriorHotkey < 300) {
        ; Wait until you physically release 'w' before holding it down virtually
        KeyWait("w")
        if !(isAutoMoving) {
            isAutoMoving := true
            Send("{Blind}{w down}")
        }
    }
}

; --- CANCELLATION KEYS (A, S, D) ---
; Pressing backwards or strafing cancels the forward hold immediately
~*s::
~*a::
~*d:: {
    global isAutoMoving
    if (isAutoMoving) {
        isAutoMoving := false
        Send "{Blind}{w up}"
    }
}
