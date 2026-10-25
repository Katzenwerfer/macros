#Requires AutoHotkey v2.0
#SingleInstance Force

#Include modules\window.ahk

; ------------------------
; === Global variables ===
; ------------------------

targetHwnd := 0
targetHwndWidth := 0
targetHwndHeight := 0
isTracking := false

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

; Hotkey: Press Alt + F12 while the target window is focused
!F12:: {
    global targetHwnd, targetHwndWidth, targetHwndHeight, isTracking

    ; Skip if already tracking
    if (isTracking) {
        return
    }

    ; Target the active window ("A")
    if !(targetHwnd := WinExist("A")) {
        return
    }

    ; Retrieve the current size of the active window
    WinGetPos(, , &targetHwndWidth, &targetHwndHeight, targetHwnd)

    ; Remove the title bar and border
    SetWindowBorderless(targetHwnd, true)

    ; Position at top-left and resize
    area := GetWorkArea()
    WinMove(0, 0, area.w, area.h, targetHwnd)

    isTracking := true
}

; Hotkey: Press Shift + F12 to restore the original title bar
+F12:: {
    global targetHwnd, targetHwndWidth, targetHwndHeight, isTracking

    ; Restore only if tracking
    if (isTracking) {
        ; Restore the title bar and border
        SetWindowBorderless(targetHwnd, false)
        ; Position at center
        CenterWindow(targetHwnd, targetHwndWidth, targetHwndHeight)
    }

    ; Cleanup global variables
    targetHwnd := 0
    targetHwndWidth := 0
    targetHwndHeight := 0
    isTracking := false
}
