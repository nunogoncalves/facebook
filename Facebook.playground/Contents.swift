import Foundation
import Cocoa
import AppKit

let fileManager = FileManager.default
let imagesUrls = fileManager.images(in: playgroundDirectory)

let refImageURL = URL(fileURLWithPath: "reference.jpg", relativeTo: playgroundDirectory)
let refImage = NSImage(contentsOf: refImageURL)!

//let refImageJPGURL = URL(fileURLWithPath: "createdReference.jpg", relativeTo: playgroundDirectory)
//try save(refImage, to: refImageJPGURL)

let testingImageURL = imagesUrls.first { $0.lastPathComponent.starts(with: "testImage") }!
let testingImage = NSImage(contentsOf: testingImageURL)!

_ = Analyser(image: refImage) { refReport in
    print("Reference Image report: ")
    print(refReport.description)
    print("")

    _ = Analyser(image: testingImage) { testingReport in
        print("Testing Image report: ")
        print(testingReport.description)

        print("==============================")
        testingReport.describeComparison(against: refReport)
    }
}

