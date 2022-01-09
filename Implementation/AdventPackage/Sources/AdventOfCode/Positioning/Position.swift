import Foundation

struct Position: Equatable {
    let depth: Depth
    let distance: HorizontalDistance
    
    static var zero: Self {
        return .init(depth: .init(value: 0), distance: .init(value: 0))
    }
}
