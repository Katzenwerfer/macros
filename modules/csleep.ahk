#Include timer.ahk

class CSleep {
    static Begin(res := 15) {
        TimerResolution.Set(res)
    }

    static Sleep(ms) {
        Alertable := false
        DelayInterval := ms * -10000
        DllCall("ntdll\NtDelayExecution", "int", Alertable, "int64*", &DelayInterval)
    }

    static Yield() {
        Alertable := false
        DelayInterval := 0
        DllCall("ntdll\NtDelayExecution", "int", Alertable, "int64*", &DelayInterval)
    }

    static End() {
        TimerResolution.Reset()
    }
}
