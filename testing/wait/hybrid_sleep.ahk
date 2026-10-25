#Include ..\..\modules\qpc.ahk
#Include ..\..\modules\stopwatch.ahk
#Include ..\..\modules\csleep.ahk
#Include ..\..\modules\stats.ahk

global SleepTimings := []
global WaitTimings := []

HybridSleep(ms, res) {
    global SleepTimings, WaitTimings

    static sleepTimer := Stopwatch()
    static waitTimer := Stopwatch()

    sleepTargetMs := res * Floor(ms / res - 2)
    sleepTargetCounts := QPC.MsToCounts(sleepTargetMs)
    waitTargetCounts := QPC.MsToCounts(ms)

    start := QPC.Query()

    sleepTarget := start + sleepTargetCounts
    waitTarget := start + waitTargetCounts

    CSleep.Begin(res)

    sleepTimer.Start()
    while (QPC.Query() < sleepTarget) {
        CSleep.Sleep(sleepTargetMs)
    }
    sleepTimer.Stop()

    CSleep.End()

    SleepTimings.Push(sleepTimer.TimeInMs())

    waitTimer.Start()
    while (QPC.Query() < waitTarget) {
        Sleep(-1)
    }
    waitTimer.Stop()

    WaitTimings.Push(waitTimer.TimeInMs())

}

SleepMs := 45

ResolutionMs := 15

Iterations := 100

LoopTimings := []
LoopTimer := Stopwatch()

Loop Iterations {
    LoopTimer.Start()
    HybridSleep(SleepMs, ResolutionMs)
    LoopTimer.Stop()
    LoopTimings.Push(LoopTimer.TimeInMs())
}

AvgTotalTime := Round(Stats.Average(LoopTimings), 3)
MaxTotalTime := Round(Stats.Maximum(LoopTimings), 3)
MinTotalTime := Round(Stats.Minimum(LoopTimings), 3)

AvgSleepTime := Round(Stats.Average(SleepTimings), 3)
MaxSleepTime := Round(Stats.Maximum(SleepTimings), 3)
MinSleepTime := Round(Stats.Minimum(SleepTimings), 3)

AvgWaitTime := Round(Stats.Average(WaitTimings), 3)
MaxWaitTime := Round(Stats.Maximum(WaitTimings), 3)
MinWaitTime := Round(Stats.Minimum(WaitTimings), 3)

MsgBox(
    "Total avg = " . AvgTotalTime . " ms`n" .
    "Total max = " . MaxTotalTime . " ms`n" .
    "Total min = " . MinTotalTime . " ms`n" .
    "Sleep avg = " . AvgSleepTime . " ms`n" .
    "Sleep max = " . MaxSleepTime . " ms`n" .
    "Sleep min = " . MinSleepTime . " ms`n" .
    "Wait avg = " . AvgWaitTime . " ms`n" .
    "Wait max = " . MaxWaitTime . " ms`n" .
    "Wait min = " . MinWaitTime . " ms"
)
