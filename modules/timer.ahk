class TimerResolution {
    static MaximumTime := (DllCall("ntdll\NtQueryTimerResolution", "uint*", &t := 0, "uint*", &_ := 0, "uint*", &_ := 0), t)
    static MinimumTime := (DllCall("ntdll\NtQueryTimerResolution", "uint*", &_ := 0, "uint*", &t := 0, "uint*", &_ := 0), t)

    static ActualTime() {
        return (DllCall("ntdll\NtQueryTimerResolution", "uint*", &_ := 0, "uint*", &_ := 0, "uint*", &t := 0), t)
    }

    static Set(ms) {
        DesiredTime := Floor(ms * 10000)
        if (DesiredTime < TimerResolution.MinimumTime) {
            DesiredTime := TimerResolution.MinimumTime
        }
        SetResolution := true
        ActualTime := 0
        DllCall("ntdll\NtSetTimerResolution", "uint", DesiredTime, "int", SetResolution, "uint*", &ActualTime)
    }

    static Reset() {
        DesiredTime := 0
        SetResolution := false
        ActualTime := 0
        DllCall("ntdll\NtSetTimerResolution", "uint", DesiredTime, "int", SetResolution, "uint*", &ActualTime)
    }
}
