class QPC {
    static frequency := (DllCall("QueryPerformanceFrequency", "int64*", &f := 0), f)

    static Query() {
        return (DllCall("QueryPerformanceCounter", "int64*", &c := 0), c)
    }

    static MsToCounts(ms) {
        return Floor(ms * QPC.frequency / 1000)
    }

    static CountsToMs(counts) {
        return counts * 1000 / QPC.frequency
    }
}
