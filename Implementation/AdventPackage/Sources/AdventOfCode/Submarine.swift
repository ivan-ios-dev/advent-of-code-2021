import Foundation

struct Submarine {
    let sonar: Sonar
    //For now let's perform sonar sweep only when depth changes,
    //not automatically in time intervals
    var position: Position {
        didSet {
            performSonarSweep()
        }
    }
    var didPerformSonarSweep: (_ depths: [Depth]) -> Void
    
    func performSonarSweep() {
        let depths = sonar.performSweep()
        didPerformSonarSweep(depths)
    }
}
