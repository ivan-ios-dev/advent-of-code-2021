import Foundation

struct Submarine {
    let sonar: Sonar
    //For now let's perform sonar sweep only when depth changes,
    //not automatically in time intervals
    var depth: Depth {
        didSet {
            performSonarSweep()
        }
    }
    var didPerformSonarSweep: (_ depths: [Depth]) -> Void
    
    func performSonarSweep() {
        let depths = sonar.performSweep()
        didPerformSonarSweep(depths)
    }
}

struct Sonar {
    var performSweep: () -> [Depth]
}

struct Depth: Equatable {
    let value: Int
}

struct DepthAnalyzer {
    enum SlidingResult {
        case wrongRange
        case reachedEnd
        case sum(Int)
    }
    
    // Returns number of times depths measurements sums increases
    // (3 items sliding window)
    static func process(input: [Depth]) throws -> Int {
        guard !input.isEmpty else {
            throw "Empty Input Error"
        }
        var lastSum = Int.max
        var count = 0
        
        for (index, _) in input.enumerated() {
            switch calcSliding3ItemSum(from: input, starting: index) {
            case .sum(let newSum):
                if newSum > lastSum {
                    count += 1
                }
                lastSum = newSum
            case .reachedEnd, .wrongRange:
                break
            }
        }
        
        return count
    }
    
    //[0,1,2,3,4,5]
    //|i,-,-|
    //       i,-,-|
    static func calcSliding3ItemSum(from input: [Depth], starting index: Int) -> SlidingResult {
        let inputRange = 0..<input.count
        guard inputRange.contains(index) else {
            return .wrongRange
        }
        
        let sliding3ItemRange = 0..<(input.count - 2)
        guard sliding3ItemRange.contains(index) else {
            return .reachedEnd
        }
        
        return .sum(
            input[index].value + input[index+1].value + input[index+2].value
        )
    }
}
