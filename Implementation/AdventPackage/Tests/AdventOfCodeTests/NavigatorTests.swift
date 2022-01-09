import XCTest
@testable import AdventOfCode

// Horizontal distance from the origin.
// For Submarine it is a distance from the ship
struct HorizontalDistance: Equatable {
    let value: Int
}

struct Position: Equatable {
    let depth: Depth
    let distance: HorizontalDistance
    
    static var zero: Self {
        return .init(depth: .init(value: 0), distance: .init(value: 0))
    }
}

struct Navigator {
    func position(from initial: Position, with route: MovementRoute) -> Position {
        guard !route.isEmpty else {
            return initial
        }
        
        var depthValue = initial.depth.value
        var distanceValue = initial.distance.value
        route.commands.forEach { command in
            switch command.direction {
            case .forward:
                distanceValue += command.amount
            case .down:
                depthValue += command.amount
            case .up:
                depthValue -= command.amount
            }
        }
        return .init(depth: .init(value: depthValue), distance: .init(value: distanceValue))
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
    
    func test_navigator_returnsNewPosition_fromInitialPosition_withMovementRoute() {
        let sut = Navigator()
        let route = MovementRoute(commands: [
            .init(direction: .forward, amount: 5),
            .init(direction: .down, amount: 5),
            .init(direction: .forward, amount: 8),
            .init(direction: .up, amount: 3),
            .init(direction: .down, amount: 8),
            .init(direction: .forward, amount: 2)
        ])
        
        let end = sut.position(from: Position.zero, with: route)
        let expectedPosition = Position.init(depth: .init(value: 10), distance: .init(value: 15))
        
        XCTAssertEqual(end.depth, expectedPosition.depth)
        XCTAssertEqual(end.distance, expectedPosition.distance)
    }
}
