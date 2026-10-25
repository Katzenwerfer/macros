#Requires AutoHotkey v2.0
#SingleInstance Force

; ---------------------
; === Configuration ===
; ---------------------

; Target window area as a percentage of the screen's work area (1 - 100).
; 50 = half the screen's area; 75 = 75% of screen area; 25 = 25% of screen area.
AreaPercent := 50

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

; Hotkey 1: Ctrl + Alt + X
^!x:: {
    global AreaPercent

    ; Get handle of the active window
    if !(hwnd := WinExist("A")) {
        return
    }

    ; If the window is maximized or minimized, restore it first
    if WinGetMinMax(hwnd) {
        WinRestore(hwnd)
    }

    ; Retrieve the monitor work area (excludes taskbar)
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top

    ; For half the area while preserving aspect ratio:
    ; Area = W * H => Half Area = (W / sqrt(2)) * (H / sqrt(2))
    ; For aspect-ratio scaling: Area = W * H.
    ; Therefore, linear scale = Sqrt(AreaPercent / 100)
    scale := Sqrt(AreaPercent / 100)
    newW := Round(workWidth * scale)
    newH := Round(workHeight * scale)

    ; Calculate centered coordinates
    newX := Round(left + (workWidth - newW) / 2)
    newY := Round(top + (workHeight - newH) / 2)

    ; Move and resize the window
    WinMove(newX, newY, newW, newH, hwnd)

    ; Redraw the window frame to apply style changes cleanly
    WinRedraw(hwnd)
}

; Hotkey 2: Ctrl + Alt + C (Center Only)
^!c:: {
    ; Get handle of the active window
    if !(hwnd := WinExist("A")) {
        return
    }

    ; If the window is maximized or minimized, restore it first
    if WinGetMinMax(hwnd) {
        WinRestore(hwnd)
    }

    ; Retrieve the current size of the active window
    WinGetPos(, , &winW, &winH, hwnd)

    ; Retrieve the monitor work area (excludes taskbar)
    ; To use the entire screen including the taskbar, use MonitorGet() instead
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top

    ; Calculate centered position based on existing window dimensions
    newX := Round(left + (workWidth - winW) / 2)
    newY := Round(top + (workHeight - winH) / 2)

    ; Move without altering dimensions
    WinMove(newX, newY, , , hwnd)

    ; Redraw the window frame to apply style changes cleanly
    WinRedraw(hwnd)
}
