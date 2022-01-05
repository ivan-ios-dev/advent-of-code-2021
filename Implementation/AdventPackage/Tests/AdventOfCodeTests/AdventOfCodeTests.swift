import XCTest
@testable import AdventOfCode

//MARK: - Tests-only code
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
    
    func test_depthAnalyzer_returnsEmptyInputError_whenInputDepthsListIsEmpty() {
        let sut = DepthAnalyzer.self
        let expectedError: Error = "Empty Input Error"
        
        XCTAssertThrowsError(try sut.process(input: [])) { error in
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func test_depthAnalyzer_returnsDepthsIncreaseCount() {
        let sut = DepthAnalyzer.self
        
        let depthIncreased1Time: [Depth] = [.init(value: 1), .init(value: 2)]
        XCTAssertEqual(try! sut.process(input: depthIncreased1Time), 1)
        
        let depthIncreasedZeroTime: [Depth] = [.init(value: 2), .init(value: 1)]
        XCTAssertEqual(try! sut.process(input: depthIncreasedZeroTime), 0)
        
        let depthIncreased2Times: [Depth] = [.init(value: 1), .init(value: 2), .init(value: 2), .init(value: 3)]
        XCTAssertEqual(try! sut.process(input: depthIncreased2Times), 2)
        
        let depthIncreasedAtTheEnd: [Depth] = [.init(value: 1), .init(value: 1), .init(value: 1), .init(value: 3)]
        XCTAssertEqual(try! sut.process(input: depthIncreasedAtTheEnd), 1)
    }
    
    func test_submarine_returnsDepthsList_whenUsingFileInputSonar_and_increasedCount_equals1139() {
        let sonar = Sonar.withDepthsFromFile(textfile: "day_1")
        
        let sut = Submarine(sonar: sonar, depth: .init(value: 0), didPerformSonarSweep: { receivedDepths in
            let increasedCount = try! DepthAnalyzer.process(input: receivedDepths)
            XCTAssertEqual(1139, increasedCount)
        })
        
        sut.performSonarSweep()
    }
    
}
