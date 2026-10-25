#Include qpc.ahk

class Stopwatch {
    begin := 0, end := 0, difference := 0

    Start() {
        this.begin := QPC.Query()
    }

    Stop() {
        this.end := QPC.Query()
        this.difference := this.end - this.begin
    }

    TimeInCounts() {
        return this.difference
    }

    TimeInMs() {
        return QPC.CountsToMs(this.difference)
    }
}
