#Include ..\..\modules\qpc.ahk
#Include ..\..\modules\stopwatch.ahk
#Include ..\..\modules\stats.ahk

BusyWait(ms) {
    target := QPC.Query() + QPC.MsToCounts(ms)
    while (QPC.Query() < target) {
        Sleep(0)
    }
}

SleepMs := 20

Iterations := 100

Timings := []
LoopTimer := Stopwatch()

Loop Iterations {
    LoopTimer.Start()
    BusyWait(SleepMs)
    LoopTimer.Stop()
    Timings.Push(LoopTimer.TimeInMs())
}

AvgTime := Stats.Average(Timings)
MaxTime := Stats.Maximum(Timings)
MinTime := Stats.Minimum(Timings)

MsgBox(
    "Wait avg = " . AvgTime . " ms`n" .
    "Wait max = " . MaxTime . " ms`n" .
    "Wait min = " . MinTime . " ms"
)
