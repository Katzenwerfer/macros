#Requires AutoHotkey v2.0
#SingleInstance Force

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

    ; Retrieve the monitor work area (excludes taskbar)
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top

    ; Remove the title bar and border
    WinSetStyle("-0xC40000", targetHwnd)

    ; Position at top-left and resize
    WinMove(0, 0, workWidth, workHeight, targetHwnd)

    ; Redraw the window frame to apply style changes cleanly
    WinRedraw(targetHwnd)

    isTracking := true
}

; Hotkey: Press Shift + F12 to restore the original title bar
+F12:: {
    global targetHwnd, targetHwndWidth, targetHwndHeight, isTracking

    ; Restore only if tracking
    if (isTracking) {
        ; Retrieve the desktop work area (excluding taskbar)
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

        workWidth := right - left
        workHeight := bottom - top

        ; Calculate centered position based on stored window dimensions
        newX := Round(left + (workWidth - targetHwndWidth) / 2)
        newY := Round(top + (workHeight - targetHwndHeight) / 2)

        ; Restore the title bar
        WinSetStyle("+0xC40000", targetHwnd)

        ; Position at center
        WinMove(newX, newY, targetHwndWidth, targetHwndHeight, targetHwnd)

        ; Redraw the window frame to apply style changes cleanly
        WinRedraw(targetHwnd)
    }

    ; Cleanup global variables
    targetHwnd := 0
    targetHwndWidth := 0
    targetHwndHeight := 0
    isTracking := false
}
