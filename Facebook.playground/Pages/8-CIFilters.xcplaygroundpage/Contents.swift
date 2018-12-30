import Foundation
import Cocoa

// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIEdges
// https://academy.realm.io/posts/tryswift-gladman-simon-advanced-core-image/

var bagUrl = playgroundDirectory
bagUrl.appendPathComponent("bag/?")

let filters = CIFilter.filterNames(inCategory: nil)
filters.forEach { print($0) }
filters.count

let ciImage = CIImage(data: refImage.tiffRepresentation!)!
let size = refImage.size

for i in stride(from: 0, to: 50, by: 2) {

    let edgesImage = ciImage.applyingFilter("CIEdges", parameters: [kCIInputIntensityKey: i])
    try save(edgesImage, to: bagUrl.appending(name: "edgeDetection-\(i).jpg"))

    let blur = ciImage.applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: i])
        .cropped(to: ciImage.extent)
    try save(blur, to: bagUrl.appending(name: "blur-\(i).jpg"))
}

