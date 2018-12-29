import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
var rotationUrl = playgroundDirectory
rotationUrl.appendPathComponent("rotation/?")

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let refImage = NSImage(contentsOf: refImageURL)!

for i in stride(from: 0, to: 361, by: 15) {
    let rotatedReferenceImage = refImage.rotated(i.degrees)

    let rotatedImageURL = URL(fileURLWithPath: "\(i)-degrees.jpg", relativeTo: rotationUrl)
    print(rotatedImageURL)
    try save(rotatedReferenceImage, to: rotatedImageURL)
}
