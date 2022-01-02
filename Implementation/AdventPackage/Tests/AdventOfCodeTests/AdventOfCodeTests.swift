import XCTest
@testable import AdventOfCode

struct Submarine {
    //For now let's perform sonar sweep only when depth changes,
    //not automatically in time intervals
    var depth: Depth {
        didSet {
            performSonarSweep()
        }
    }
    
    var didPerformSonarSweep: (_ depths: [Depth]) -> Void
    
    func performSonarSweep() {
        let result: [Depth] = []
        didPerformSonarSweep(result)
    }
}

struct Depth {
    let value: Int
}

final class AdventOfCodeTests: XCTestCase {
    
    func test_submarine_performsSonarSweep_whenItsDepthIsGreaterThanZero() {
        
        var sonarSweepPerformedCount = 0
        var sut = Submarine(depth: .init(value: 0), didPerformSonarSweep: { _ in
            sonarSweepPerformedCount += 1
        })
        
        //Assert that when submarine is not below the surface,
        //it does not perform sonar sweep
        XCTAssertEqual(sonarSweepPerformedCount, 0)
        
        sut.depth = .init(value: 10)
        
        //Assert that when submarine is below the surface,
        //it performs sonar sweep
        XCTAssertEqual(sonarSweepPerformedCount, 1)
    }
    
    
}
