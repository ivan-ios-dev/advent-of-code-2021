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
    func position(from initial: Position, with route: MovementRoute) throws -> Position {
        guard !route.isEmpty else {
            return initial
        }
        
        var depthValue = initial.depth.value
        var distanceValue = initial.distance.value
        try route.commands.forEach { command in
            switch command.direction {
            case .forward:
                distanceValue += command.amount
            case .down:
                depthValue += command.amount
            case .up:
                depthValue -= command.amount
            }
            // Submarine won't be able to perform this command, thus calculated final
            // position will be wrong, so we throw an error in this case
            if depthValue < 0 {
                throw "WrongMovementRoute"
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

private extension MovementRoute {
    static func read(from textfile: String) -> Self {
        let data = TestBundle.inputData(from: textfile)
        let str = String(decoding: data, as: UTF8.self)
        
        let commands = str
            .components(separatedBy: "\n")
            .filter{ !$0.isEmpty }
            .compactMap{ MovementCommand.fromString(input: $0) }
    
        return .init(commands: commands)
    }
}

struct MovementCommand {
    enum Direction: String {
        case forward
        case up
        case down
    }
    
    let direction: Direction
    let amount: Int
}

private extension MovementCommand {
    static func fromString(input: String) -> Self? {
        let components = input.components(separatedBy: .whitespaces)
        guard components.count == 2 else {
            return nil
        }
                
        guard let direction = Direction(rawValue: components[0]),
                let amount = Int(components[1]) else {
            return nil
        }
        return MovementCommand(direction: direction, amount: amount)
    }
}


final class NavigatorTests: XCTestCase {
    
    func test_navigator_returnsInitialPosition_withEmptyMovementRoute() {
        let sut = Navigator()
        let start = Position.zero
        let route = MovementRoute.empty
        
        let end = try! sut.position(from: start, with: route)
        
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
        
        let end = try! sut.position(from: .zero, with: route)
        let expectedPosition = Position.init(depth: .init(value: 10), distance: .init(value: 15))
        
        XCTAssertEqual(end.depth, expectedPosition.depth)
        XCTAssertEqual(end.distance, expectedPosition.distance)
    }
    
    func test_navigator_returnsWrongMovementRouteError_whenFinalDepthHasNegativeValue() {
        let sut = Navigator()
        let route = MovementRoute(commands: [
            .init(direction: .forward, amount: 10),
            .init(direction: .down, amount: 5),
            .init(direction: .up, amount: 10)
        ])
        let expectedError: Error = "WrongMovementRoute"
        
        XCTAssertThrowsError(
            try sut.position(from: .zero, with: route)
        ) { error in
            XCTAssertEqual(
                error.localizedDescription,
                expectedError.localizedDescription
            )
        }
    }
    
    func test_navigator_returnsNewPosition_fromInitialPosition_withMovementRouteParsedFromFile() {
        let sut = Navigator()
        let route = MovementRoute.read(from: "day_2")
        
        let end = try! sut.position(from: .zero, with: route)
        
        XCTAssertEqual(end.depth.value, 916)
        XCTAssertEqual(end.distance.value, 1845)
        XCTAssertEqual(end.depth.value * end.distance.value, 1_690_020)
    }
}
