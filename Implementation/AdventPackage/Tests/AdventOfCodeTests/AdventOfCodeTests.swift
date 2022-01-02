import XCTest
@testable import AdventOfCode

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

//MARK: - Tests-only code
extension Sonar {
    static func withMockDepths(mock: [Depth]) -> Self {
        return Self.init { return mock }
    }
    static var empty: Self {
        return Self.withMockDepths(mock: [])
    }
}


final class AdventOfCodeTests: XCTestCase {
    
    func test_submarine_performsSonarSweep_whenItsDepthIsGreaterThanZero() {
        var sonarSweepPerformedCount = 0
        var sut = Submarine(sonar: .empty, depth: .init(value: 0), didPerformSonarSweep: { _ in
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
    
    func test_submarine_providesDepthList_whenPerformSonarSweepIsCalled() {
        let mockDepths: [Depth] = [.init(value: 10), .init(value: 20), .init(value: 30)]
        let sonar = Sonar.withMockDepths(mock: mockDepths)
        
        let sut = Submarine(sonar: sonar, depth: .init(value: 0), didPerformSonarSweep: { receivedDepths in
            XCTAssertEqual(mockDepths, receivedDepths)
        })
        
        sut.performSonarSweep()
    }
}
