import Foundation
import Cocoa
import AppKit

var rotatedCropUrl = playgroundDirectory
rotatedCropUrl.appendPathComponent("rotationCrop/?")

let size = refImage.size

let ciRefImage = CIImage(data: refImage.tiffRepresentation!)!
let blur = ciRefImage.applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: 10])
    .cropped(to: ciRefImage.extent)

for i in stride(from: 0, to: 361, by: 15) {

    let transform = CGAffineTransform(translationX: size.width / 2, y: size.height / 2)
        .rotated(by: CGFloat(i.degrees.rads.value))
        .translatedBy(x: -size.width / 2, y: -size.height / 2)

    let rotatedCI = ciRefImage.transformed(by: transform)

    let result = rotatedCI.composited(over: blur).cropped(to: size.framed)

    try save(result, to: rotatedCropUrl.appending(name: "blurAndRotated-\(i)-degrees.jpg"))
}
