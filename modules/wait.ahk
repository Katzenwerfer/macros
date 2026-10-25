#Include qpc.ahk

Wait(counts) {
    target := QPC.Query() + counts

    while (QPC.Query() < target) {
        Sleep(-1)
    }
}

WaitMs(ms) {
    target := QPC.Query() + QPC.MsToCounts(ms)

    while (QPC.Query() < target) {
        Sleep(-1)
    }
}
