import Foundation

struct MovementRoute {
    let commands: [MovementCommand]
    
    var isEmpty: Bool {
        return commands.isEmpty
    }
}

