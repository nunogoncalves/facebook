import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let testingImageURL = imagesUrls.first { $0.lastPathComponent.starts(with: "testImage") }!

let refImage = NSImage(contentsOf: refImageURL)!
let testingImage = NSImage(contentsOf: testingImageURL)!

_ = Analyser(image: refImage) { refReport in
    print("Reference Image report: ")
    print(refReport.description)
    print("")

    _ = Analyser(image: testingImage) { testingReport in
        print("Testing Image report: ")
        print(testingReport.description)

        print("==============================")
        print("Comparison")
        testingReport.describeComparison(against: refReport)
    }
}

