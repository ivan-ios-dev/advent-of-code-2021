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
    static func process(input: [Depth]) throws -> Int {
        guard !input.isEmpty else {
            throw "Empty Input Error"
        }
        var count = 0
        for i in 1..<input.count {
            if input[i].value > input[i-1].value {
                count += 1
            }
        }
        return count
    }
}
