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

; -----------------
; === Functions ===
; -----------------

; Retrieve the desktop work area (excluding taskbar)
GetWorkArea() {
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
    return {
        x: left,
        y: top,
        w: right - left,
        h: bottom - top
    }
}

; Remove the title bar and border
SetWindowBorderless(hwnd, borderless := true) {
    WinSetStyle((borderless ? "-" : "+") . "0xC40000", hwnd)
    WinRedraw(hwnd)
}

; Position at the center of the work area
CenterWindow(hwnd, hwndWidth, hwndHeight) {
    bounds := GetWorkArea()
    x := Round(bounds.x + (bounds.w - hwndWidth) / 2)
    y := Round(bounds.y + (bounds.h - hwndHeight) / 2)
    WinMove(x, y, hwndWidth, hwndHeight, hwnd)
    WinRedraw(hwnd)
}
