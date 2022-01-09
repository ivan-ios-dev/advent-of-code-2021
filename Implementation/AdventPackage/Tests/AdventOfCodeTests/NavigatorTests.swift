import XCTest
@testable import AdventOfCode

// Horizontal distance from the origin.
// For Submarine it is a distance from the ship
struct HorizontalDistance: Equatable {
    let amount: Int
}

struct Position: Equatable {
    let depth: Depth
    let distance: HorizontalDistance
    
    static var zero: Self {
        return .init(depth: .init(value: 0), distance: .init(amount: 0))
    }
}

struct Navigator {
    
    func position(from initial: Position, with route: MovementRoute) -> Position {
        return initial
    }
}

struct MovementRoute {
    let commands: [MovementCommand]
    
    var isEmpty: Bool {
        return commands.isEmpty
    }
    
    static var empty: Self {
        return .init(commands: [])
    }
}

struct MovementCommand {
    enum Direction {
        case forward
        case up
        case down
    }
    
    let direction: Direction
    let amount: Int
}


final class NavigatorTests: XCTestCase {
    
    func test_navigator_returnsInitialPosition_withEmptyMovementRoute() {
        let sut = Navigator()
        let start = Position.zero
        let route = MovementRoute.empty
        
        let end = sut.position(from: start, with: route)
        
        XCTAssertEqual(start, end)
    }
    
}
