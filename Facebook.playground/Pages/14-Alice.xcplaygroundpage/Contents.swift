import Foundation
import Cocoa
import AppKit

//let person = Person.nuno
let person = Person.alice
let refImagePerson = refImage(for: person)

let destinationURL = playgroundDirectory.appendingPathComponent("results\(person.rawValue)/?")
let imagesURLs = FileManager.default
    .images(in: playgroundDirectory.appendingPathComponent("sourceImages\(person.rawValue)"))
    .sorted(by: \.lastPathComponent)

var refRep: FaceReport!
Analyser(image: refImagePerson) { report in print(report.description); refRep = report }

let processor = Processor2(referenceImage: refImagePerson, comparisonType: .pupils)

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

    let rep = Analyser(image: image) { report in
        print(report.description)

        print("!!!")

        report.describeComparison(against: refRep)
    }

    let processedImage = processor.processed(image)

    var name = url.lastPathComponent
    let index = (name.range(of: " - ")!.lowerBound)
    name = String(name.prefix(upTo: index))

    try save(processedImage, to: destinationURL.appending(name: "\(name).jpg"), compression: 0.1)
    let endImage = Date()

    let duration = (endImage.timeIntervalSince1970 - startImage.timeIntervalSince1970).oneDecimal
    print("Took \(duration) seconds to process \(url.lastPathComponent)")
}
let end = Date()

let duration = (end.timeIntervalSince1970 - start.timeIntervalSince1970).oneDecimal
print("Took \(duration / 60) minutes to process \(imagesURLs.count) images")
