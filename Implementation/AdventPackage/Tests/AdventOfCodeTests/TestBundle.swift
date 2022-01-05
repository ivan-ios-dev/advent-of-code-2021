import Foundation

final class TestBundle {

    static func inputData(from textfile: String) -> Data {
        let inputsBundlePath = Bundle.module.path(forResource: "inputs", ofType: "bundle")!
        let txtFilePath: String = inputsBundlePath + "/\(textfile).txt"
        return try! Data.init(contentsOf: URL(fileURLWithPath: txtFilePath))
    }
}

