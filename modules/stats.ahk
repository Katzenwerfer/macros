class Stats {
    static Average(arr) {
        if (arr.Length == 0) {
            return 0
        }
        sum := 0
        for value in arr {
            sum += value
        }
        return sum / arr.Length
    }

    static Maximum(arr) {
        if (arr.Length == 0) {
            return ""
        }
        maxVal := arr[1]
        for value in arr {
            if (value > maxVal) {
                maxVal := value
            }
        }
        return maxVal
    }

    static Minimum(arr) {
        if (arr.Length == 0) {
            return ""
        }
        minVal := arr[1]
        for value in arr {
            if (value < minVal) {
                minVal := value
            }
        }
        return minVal
    }
}
