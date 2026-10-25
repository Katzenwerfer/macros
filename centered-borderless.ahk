#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------
; === Global variables ===
; ------------------------

bgGui := ""
targetHwnd := 0
targetHwndWidth := 0
targetHwndHeight := 0
isTracking := false
isBackdropVisible := false

; ---------------
; === Hotkeys ===
; ---------------

; Hotkey to reload the script
F1 & F2:: Reload()
; Hotkey to exit the script
F1 & ESC:: ExitApp()

; Hotkey: Press Alt + F12 while the target window is focused to center, remove decorations, and add a dark background behind it
!F12:: {
    global bgGui, targetHwnd, targetHwndWidth, targetHwndHeight, isTracking, isBackdropVisible

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

    ; Retrieve the current size of the active window client
    WinGetClientPos(, , &winCliW, &winCliH, targetHwnd)

    ; Retrieve the desktop work area (excluding taskbar)
    MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top

    ; Calculate centered position based on existing window dimensions
    newX := Round(left + (workWidth - winCliW) / 2)
    newY := Round(top + (workHeight - winCliH) / 2)

    ; Remove the title bar and border
    WinSetStyle("-0xC40000", targetHwnd)

    ; Position at center and resize
    WinMove(newX, newY, winCliW, winCliH, targetHwnd)

    ; Redraw the window frame to apply style changes cleanly
    WinRedraw(targetHwnd)

    ; Create a borderless, non-clickable black background
    bgGui := Gui("-Caption +ToolWindow +Disabled")
    bgGui.BackColor := "000000"

    ; Cover the virtual screen (all monitors)
    MonitorGet(MonitorGetPrimary(), &left, &top, &right, &bottom)
    bgGui.Show(Format("x{} y{} w{} h{} NoActivate", left, top, right, bottom))

    ; Place directly behind the target window in Z-order
    ; 0x53 = SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE | SWP_SHOWWINDOW
    DllCall("SetWindowPos", "Ptr", bgGui.Hwnd, "Ptr", targetHwnd, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x53)

    isTracking := true
    isBackdropVisible := true

    ; Monitor window focus and existence every 50ms
    SetTimer(MonitorWindow, 1000)
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

        ; Restore the title bar and border
        WinSetStyle("+0xC40000", targetHwnd)

        ; Position at center and resize
        WinMove(newX, newY, targetHwndWidth, targetHwndHeight, targetHwnd)

        ; Redraw the window frame to apply style changes cleanly
        WinRedraw(targetHwnd)
    }

    CleanupRuntime()
}

; -----------------
; === Functions ===
; -----------------

MonitorWindow() {
    global bgGui, targetHwnd, isBackdropVisible

    ; 1. If the recorded window was closed or killed, clean up completely
    if !(WinExist("ahk_id " targetHwnd)) {
        CleanupRuntime()
        return
    }

    ; 2. If the recorded window is active
    if (WinActive("ahk_id " targetHwnd)) {
        if !(isBackdropVisible) {
            ; Restore the backdrop without stealing focus
            bgGui.Show("NoActivate")

            ; Re-insert directly beneath the active window in the Z-order
            DllCall("SetWindowPos", "Ptr", bgGui.Hwnd, "Ptr", targetHwnd, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x53)

            isBackdropVisible := true
        }
    }
    ; 3. If the recorded window lost focus (clicked away, minimized, Alt+Tabbed)
    else {
        if (isBackdropVisible) {
            bgGui.Hide()
            isBackdropVisible := false
        }
    }
}

CleanupRuntime() {
    global bgGui, targetHwnd, targetHwndWidth, targetHwndHeight, isTracking, isBackdropVisible

    ; Stop the timer
    SetTimer(MonitorWindow, 0)

    ; Destroy the GUI and reset variables
    if (bgGui is Gui) {
        bgGui.Destroy()
        bgGui := ""
    }

    targetHwnd := 0
    targetHwndWidth := 0
    targetHwndHeight := 0
    isTracking := false
    isBackdropVisible := false
}
