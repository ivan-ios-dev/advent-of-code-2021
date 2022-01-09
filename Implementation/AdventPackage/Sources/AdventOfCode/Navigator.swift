import Foundation

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
