import Foundation

struct MovementCommand {
    enum Direction: String {
        case forward
        case up
        case down
    }
    
    let direction: Direction
    let amount: Int
}
