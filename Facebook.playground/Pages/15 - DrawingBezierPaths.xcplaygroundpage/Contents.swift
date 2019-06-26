//: [Previous](@previous)

import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory.appending(name: "facelines_Alice"))
//let testingImageURL = imagesUrls.first { $0.lastPathComponent.starts(with: "ref_test") }!
//let testingImage = NSImage(contentsOf: testingImageURL)!

let person = Person.alice
let destinationURL = playgroundDirectory.appendingPathComponent("facelines_\(person.rawValue)/?")

//let image = testingImage

let size: CGFloat = 50
let pupilSize = CGSize(width: size, height: size)

func applyProps(to path: NSBezierPath) {
    path.lineWidth = 5
    path.fill()
    path.stroke()
}

func draw(in image: NSImage, basedOn report: Facebook_Sources.FaceReport, name: String) {
    image.lockFocus()

    NSColor.black.set()
//    let leftEyePath = report.leftEyePoints.bezierPath
//    applyProps(to: leftEyePath)
//
//    let rightEyePath = report.rightEyePoints.bezierPath
//    applyProps(to: rightEyePath)

    NSColor.green.set()
    let leftPupil = CGRect(center: report.leftPupilPoint, size: pupilSize)
    let leftPupilPath = NSBezierPath(roundedRect:  leftPupil, xRadius: size, yRadius: size)
    applyProps(to: leftPupilPath)

    let rightPupil = CGRect(center: report.rightPupilPoint, size: pupilSize)
    let rightPupilPath = NSBezierPath(roundedRect: rightPupil, xRadius: size, yRadius: size)

    applyProps(to: rightPupilPath)


    NSColor.red.set()
    let pupilsLine = NSBezierPath(from: report.leftPupilPoint, to: report.rightPupilPoint)
    applyProps(to: pupilsLine)

    NSColor.purple.set()
    let lineBetweenEyesCentroids = NSBezierPath(
        from: report.leftEyePoints.centroid,
        to: report.rightEyePoints.centroid
    )
    applyProps(to: lineBetweenEyesCentroids)


    image.unlockFocus()

    try! save(image, to: destinationURL.appending(name: name), compression: 0.1)
    image

}

imagesUrls.forEach { url in
    print(url.lastPathComponent.starts(with: "000"))
    if url.lastPathComponent.starts(with: "000") { return }
    let image = NSImage(contentsOf: url)!
    _ = Analyser(image: image) { refReport in
        print(url.lastPathComponent)
        draw(in: image, basedOn: refReport, name: "2_lines_\(url.lastPathComponent)")
    }
}


//: [Next](@next)

