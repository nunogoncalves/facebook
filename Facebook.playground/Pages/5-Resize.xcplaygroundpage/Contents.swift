
import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
var resizedUrl = playgroundDirectory
resizedUrl.appendPathComponent("resize/?")

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let refImage = NSImage(contentsOf: refImageURL)!

extension NSImage {

    public func resized(to targetSize: NSSize) -> NSImage? {

        let frame = NSRect(origin: .zero, size: targetSize)

        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize, flipped: false) { _ in
            return representation.draw(in: frame)
        }
        return image
    }
}
let oldSize = refImage.size

let resizes = [2, 0.1, 0.5]

for multiplier in resizes {

    let resizedImage = refImage.resized(to: oldSize.times(multiplier))!

    let resizedImageURL = URL(fileURLWithPath: "multiplier-\(multiplier).jpg", relativeTo: resizedUrl)
    try save(resizedImage, to: resizedImageURL)
}

