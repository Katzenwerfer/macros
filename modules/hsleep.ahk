#Include qpc.ahk
#Include csleep.ahk

HSleep(ms, res := 15.625) {
    start := QPC.Query()

    waitTargetCounts := start + QPC.MsToCounts(ms)

    sleepTargetMs := res * Floor(ms / res - 2)
    sleepTargetCounts := start + QPC.MsToCounts(sleepTargetMs)

    CSleep.Begin(res)

    while (QPC.Query() < sleepTargetCounts) {
        CSleep.Sleep(sleepTargetMs)
    }

    CSleep.End()

    while (QPC.Query() < waitTargetCounts) {
        Sleep(-1)
    }
}
