; Retrieve the monitor area
GetMonitorArea() {
    MonitorGet(MonitorGetPrimary(), &left, &top, &right, &bottom)
    return {
        x: left,
        y: top,
        w: right - left,
        h: bottom - top
    }
}

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

GetWindowArea(hwnd) {
    WinGetPos(&outX, &outY, &outWidth, &outHeight, hwnd)
    return {
        x: outX,
        y: outY,
        w: outWidth,
        h: outHeight
    }
}

GetClientArea(hwnd) {
    WinGetClientPos(&outX, &outY, &outWidth, &outHeight, hwnd)
    return {
        x: outX,
        y: outY,
        w: outWidth,
        h: outHeight
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
