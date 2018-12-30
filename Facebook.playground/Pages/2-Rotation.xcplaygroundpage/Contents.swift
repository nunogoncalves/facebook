import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
var rotationUrl = playgroundDirectory
rotationUrl.appendPathComponent("rotation/?")

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let refImage = NSImage(contentsOf: refImageURL)!

for i in stride(from: 0, to: 361, by: 15) {

    let rotatedReferenceImageIK = refImage.rotatedUsingIKImageView(i.degrees)
    let rotatedImageURLIK = URL(fileURLWithPath: "ikImageView-\(i)-degrees.jpg", relativeTo: rotationUrl)
    print(rotatedImageURLIK)
    try save(rotatedReferenceImageIK, to: rotatedImageURLIK)

    let rotatedReferenceImageCI = refImage.rotatedUsingCIImage(i.degrees)!
    let rotatedImageURLCI = URL(fileURLWithPath: "CIImage-\(i)-degrees.jpg", relativeTo: rotationUrl)
    print(rotatedImageURLCI)
    try save(rotatedReferenceImageCI, to: rotatedImageURLCI)
}
