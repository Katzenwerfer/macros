#Include ..\..\modules\qpc.ahk
#Include ..\..\modules\stopwatch.ahk
#Include ..\..\modules\csleep.ahk
#Include ..\..\modules\stats.ahk

SleepMs := 15

ResolutionMs := 15

Iterations := 100

Timings := []
LoopTimer := Stopwatch()


CSleep.Begin(ResolutionMs)

Loop Iterations {
    LoopTimer.Start()
    CSleep.Sleep(SleepMs)
    LoopTimer.Stop()
    Timings.Push(LoopTimer.TimeInMs())
}

CSleep.End()

AvgTime := Stats.Average(Timings)
MaxTime := Stats.Maximum(Timings)
MinTime := Stats.Minimum(Timings)

MsgBox(
    "Sleep avg = " . AvgTime . " ms`n" .
    "Sleep max = " . MaxTime . " ms`n" .
    "Sleep min = " . MinTime . " ms"
)
