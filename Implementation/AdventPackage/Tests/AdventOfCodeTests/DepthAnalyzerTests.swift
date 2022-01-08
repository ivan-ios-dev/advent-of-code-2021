import XCTest
@testable import AdventOfCode

final class DepthAnalyzerTests: XCTestCase {
    
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
        
}
