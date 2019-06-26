//: [Previous](@previous)

import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
let testingImageURL = imagesUrls.first { $0.lastPathComponent.starts(with: "ref_test") }!
let testingImage = NSImage(contentsOf: testingImageURL)!

let image = testingImage

let size: CGFloat = 50
let pupilSize = CGSize(width: size, height: size)

func applyProps(to path: NSBezierPath) {
    path.lineWidth = 5
    path.fill()
    path.stroke()
}
_ = Analyser(image: image) { refReport in
//    print("Reference Image report: ")
//    print(refReport.description)
//    print("")

    image.lockFocus()

//    NSColor.black.set()
//    let leftEyePath = refReport.leftEyePoints.bezierPath
//    applyProps(to: leftEyePath)

//    let rightEyePath = refReport.rightEyePoints.bezierPath
//    applyProps(to: rightEyePath)

    NSColor.green.set()
    let leftPupil = CGRect(center: refReport.leftPupilPoint, size: pupilSize)
    let leftPupilPath = NSBezierPath(roundedRect:  leftPupil, xRadius: size, yRadius: size)
    applyProps(to: leftPupilPath)

    let rightPupil = CGRect(center: refReport.rightPupilPoint, size: pupilSize)
    let rightPupilPath = NSBezierPath(roundedRect:  rightPupil, xRadius: size, yRadius: size)

    applyProps(to: rightPupilPath)


//    NSColor.red.set()
//    let pupilsLine = NSBezierPath(from: refReport.leftPupilPoint, to: refReport.rightPupilPoint)
//    pupilsLine.lineWidth = 5
//    pupilsLine.fill()
//    pupilsLine.stroke()

    NSColor.purple.set()
//    let lineBetweenEyesCentroids = NSBezierPath(
//        from: refReport.leftEyePoints.centroid,
//        to: refReport.rightEyePoints.centroid
//    )
//    applyProps(to: lineBetweenEyesCentroids)

    let path = NSBezierPath()

    path.move(to: NSPoint(x: 1671.6902328536642, y: 1496.8434678308297))
    path.line(to: NSPoint(x: 1731.4300095734375, y: 1531.8762915676812))
    path.line(to: NSPoint(x: 1803.0423659768453, y: 1537.9033761225899))
    path.line(to: NSPoint(x: 1873.9008896784512, y: 1516.80838993393))
    path.line(to: NSPoint(x: 1927.7985961318082, y: 1456.5369355961093))
    path.line(to: NSPoint(x: 1866.3627529069292, y: 1438.4554536356081))
    path.line(to: NSPoint(x: 1790.604430791509, y: 1434.3118092232985))
    path.line(to: NSPoint(x: 1720.8765990686575, y: 1452.7699031137277))
    path.line(to: NSPoint(x: 1671.6902328536642, y: 1496.8434678308297))
    path.close()
    applyProps(to: path)


    image.unlockFocus()

    image
}


//: [Next](@next)

