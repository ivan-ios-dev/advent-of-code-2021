import XCTest
@testable import AdventOfCode

private extension Depth {
    static func readDepths(from textfile: String) -> [Depth] {
        let data = TestBundle.inputData(from: textfile)
        let str = String(decoding: data, as: UTF8.self)
        
        let depths = str
            .components(separatedBy: "\n")
            .filter{ !$0.isEmpty }
            .compactMap{ Int($0) }
            .map{ Depth.init(value: $0) }
        return depths
    }
}

extension Sonar {
    static func withMockDepths(mock: [Depth]) -> Self {
        return Self.init { return mock }
    }
    static var empty: Self {
        return Self.withMockDepths(mock: [])
    }
    static func withDepthsFromFile(textfile: String) -> Self {
        return Self.init {
            return Depth.readDepths(from: textfile)
        }
    }
}

final class SubmarineTests: XCTestCase {

    func test_submarine_performsSonarSweep_whenItsDepthIsGreaterThanZero() {
        var sonarSweepPerformedCount = 0
        var sut = Submarine(sonar: .empty, position: .zero, didPerformSonarSweep: { _ in
            sonarSweepPerformedCount += 1
        })
        
        //Assert that when submarine is not below the surface,
        //it does not perform sonar sweep
        XCTAssertEqual(sonarSweepPerformedCount, 0)
        
        sut.position = .init(depth: .init(value: 10), distance: .init(value: 0))
        
        //Assert that when submarine is below the surface,
        //it performs sonar sweep
        XCTAssertEqual(sonarSweepPerformedCount, 1)
    }
    
    func test_submarine_providesDepthList_whenPerformSonarSweepIsCalled() {
        let mockDepths: [Depth] = [.init(value: 10), .init(value: 20), .init(value: 30)]
        let sonar = Sonar.withMockDepths(mock: mockDepths)
        
        let sut = Submarine(sonar: sonar, position: .zero, didPerformSonarSweep: { receivedDepths in
            XCTAssertEqual(mockDepths, receivedDepths)
        })
        
        sut.performSonarSweep()
    }
    
    func test_submarine_returnsDepthsList_whenUsingFileInputSonar_and_increasedCount_equals1103() {
        let sonar = Sonar.withDepthsFromFile(textfile: "day_1")
        
        let sut = Submarine(sonar: sonar, position: .zero, didPerformSonarSweep: { receivedDepths in
            let increasedCount = try! DepthAnalyzer.process(input: receivedDepths)
            XCTAssertEqual(1103, increasedCount)
        })
        
        sut.performSonarSweep()
    }
}
