class Window {
    ; Retrieve the monitor area
    static GetMonitorArea() {
        MonitorGet(MonitorGetPrimary(), &left, &top, &right, &bottom)
        return {
            x: left,
            y: top,
            w: right - left,
            h: bottom - top
        }
    }

    ; Retrieve the desktop work area (excluding taskbar)
    static GetWorkArea() {
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        return {
            x: left,
            y: top,
            w: right - left,
            h: bottom - top
        }
    }

    ; Get the window area
    static GetWindowArea(hwnd) {
        WinGetPos(&outX, &outY, &outWidth, &outHeight, hwnd)
        return {
            x: outX,
            y: outY,
            w: outWidth,
            h: outHeight
        }
    }

    ; Get the window client area
    static GetClientArea(hwnd) {
        WinGetClientPos(&outX, &outY, &outWidth, &outHeight, hwnd)
        return {
            x: outX,
            y: outY,
            w: outWidth,
            h: outHeight
        }
    }

    ; Remove the title bar and border
    static SetWindowBorderless(hwnd, borderless := true) {
        WinSetStyle((borderless ? "-" : "+") . "0xC40000", hwnd)
        WinRedraw(hwnd)
    }

    ; Position at the center of the work area
    static CenterWindow(hwnd, hwndWidth, hwndHeight) {
        bounds := Window.GetWorkArea()
        x := Round(bounds.x + (bounds.w - hwndWidth) / 2)
        y := Round(bounds.y + (bounds.h - hwndHeight) / 2)
        WinMove(x, y, hwndWidth, hwndHeight, hwnd)
        WinRedraw(hwnd)
    }
}
