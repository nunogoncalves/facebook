import Foundation
import Cocoa
import AppKit

let destinationURL = playgroundDirectory.appendingPathComponent("tests/?")
let imagesURLs = FileManager.default
    .images(in: playgroundDirectory.appendingPathComponent("sourceImages"))

let processor = Processor(referenceImage: refImage)

for url in imagesURLs {
    let image = NSImage(contentsOf: url)!
    let processedImage = processor.processed(image)
    try save(processedImage, to: destinationURL.appending(name: "\(url.lastPathComponent).jpg"))
}


