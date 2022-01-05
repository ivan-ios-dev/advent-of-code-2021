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
    
    func test_depthAnalyzer_returnsDepthsSumIncreasedCount_whenUsing3itemSlidingWindow() {
        //example depths from Advent website
        let depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
        let sut = DepthAnalyzer.self
        
        let increased1Time: [Depth] = depths.prefix(4).map{ Depth.init(value: $0) }
        XCTAssertEqual(try! sut.process(input: increased1Time), 1)
        
        let notIncreased: [Depth] = depths[2...5].map{ Depth.init(value: $0) }
        XCTAssertEqual(try! sut.process(input: notIncreased), 0)
        
        let increased5Times: [Depth] = depths.map{ Depth.init(value: $0) }
        XCTAssertEqual(try! sut.process(input: increased5Times), 5)
    }
    
    func test_submarine_returnsDepthsList_whenUsingFileInputSonar_and_increasedCount_equals1103() {
        let sonar = Sonar.withDepthsFromFile(textfile: "day_1")
        
        let sut = Submarine(sonar: sonar, depth: .init(value: 0), didPerformSonarSweep: { receivedDepths in
            let increasedCount = try! DepthAnalyzer.process(input: receivedDepths)
            XCTAssertEqual(1103, increasedCount)
        })
        
        sut.performSonarSweep()
    }
    
}
