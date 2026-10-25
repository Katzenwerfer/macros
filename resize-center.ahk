#Requires AutoHotkey v2.0
#SingleInstance Force

#include modules\window.ahk

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
    area := Window.GetWorkArea()

    ; For half the area while preserving aspect ratio:
    ; Area = W * H => Half Area = (W / sqrt(2)) * (H / sqrt(2))
    ; For aspect-ratio scaling: Area = W * H.
    ; Therefore, linear scale = Sqrt(AreaPercent / 100)
    scale := Sqrt(AreaPercent / 100)
    newW := Round(area.w * scale)
    newH := Round(area.h * scale)

    ; Move and resize the window
    Window.CenterWindow(hwnd, newW, newH)
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
    hwndArea := Window.GetWindowArea(hwnd)

    Window.CenterWindow(hwnd, hwndArea.w, hwndArea.h)
}
