import XCTest
@testable import AdventOfCode

struct Submarine {
    var depth: Depth {
        didSet {
            didPerformSonarSweep([])
        }
    }
    
    var didPerformSonarSweep: (_ depths: [Depth]) -> Void
    
    
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
