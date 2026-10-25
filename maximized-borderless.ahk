#Requires AutoHotkey v2.0
#SingleInstance Force

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

; Hotkey: Press Alt + F12 while the target window is focused
!F12:: {
    ; Target the active window ("A")
    if !(hwnd := WinExist("A")) {
        return
    }

    ; Retrieve the monitor work area (excludes taskbar)
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top

    ; Remove the title bar and border
    WinSetStyle("-0xC40000", hwnd)

    ; Position at top-left and resize
    WinMove(0, 0, workWidth, workHeight, hwnd)

    ; Redraw the window frame to apply style changes cleanly
    WinRedraw(hwnd)
}

; Hotkey: Press Shift + F12 to restore the original title bar
+F12:: {
    hwnd := WinGetID("A")
    WinSetStyle("+0xC40000", hwnd)
    WinRedraw(hwnd)
}
