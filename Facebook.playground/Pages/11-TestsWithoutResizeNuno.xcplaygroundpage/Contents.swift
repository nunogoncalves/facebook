import Foundation
import Cocoa
import AppKit

let destinationURL = playgroundDirectory.appendingPathComponent("resultsNuno/?")
let imagesURLs = FileManager.default
    .images(in: playgroundDirectory.appendingPathComponent("sourceImagesNuno"))
    .sorted(by: \.lastPathComponent)

let processor = Processor2(referenceImage: refImage)

let start = Date()
print("Processing \(imagesURLs.count)")

public func image(with number: Int) {

    let size = CGSize(width: 120, height: 40)

    let textView = NSTextView(frame: CGRect(origin: .zero, size: size))
    textView.string = "\(number)"
    textView.alignment = .right
    textView.textStorage?.font = NSFont.systemFont(ofSize: 40)

    textView.setTextColor(.white, range: NSRange(location: 0, length: textView.textStorage!.length))

    let bi = textView.bitmapImageRepForCachingDisplay(in: size.framed)!
    bi.size = size
    textView.cacheDisplay(in: size.framed, to: bi)

    let nsImage = NSImage(size: size)
    nsImage.addRepresentation(bi)
    nsImage
}

for url in imagesURLs {

    let startImage = Date()
    let image = NSImage(contentsOf: url)!
    let processedImage = processor.processed(image)

    var name = url.lastPathComponent
    let index = (name.range(of: " - ")!.lowerBound)
    name = String(name.prefix(upTo: index))

    let ciImage = image(with: 1234).ciImage
    

    try save(processedImage, to: destinationURL.appending(name: "\(name).jpg"), compression: 0.1)
    let endImage = Date()

    let duration = (endImage.timeIntervalSince1970 - startImage.timeIntervalSince1970).oneDecimal
    print("Took \(duration) seconds to process \(url.lastPathComponent)")
}
let end = Date()

let duration = (end.timeIntervalSince1970 - start.timeIntervalSince1970).oneDecimal
print("Took \(duration / 60) minutes to process \(imagesURLs.count) images")
