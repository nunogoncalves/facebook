import Foundation
import Cocoa

public struct Processor2 {

    private let referenceImage: NSImage
    private let referenceCIImage: CIImage
    private var referenceReport: FaceReport!
    private let referenceSize: CGSize

    public init(referenceImage: NSImage) {
        self.referenceImage = referenceImage
        self.referenceCIImage = referenceImage.ciImage
        self.referenceSize = referenceImage.size

        var refReport: FaceReport!
        _ = Analyser(image: referenceImage) { refReport = $0 }
        self.referenceReport = refReport
    }

    public func processed(_ image: NSImage) -> NSImage {

        var imageReport: FaceReport!

        _ = Analyser(image: image) { imageReport = $0 }

        print(referenceReport.imageSize)
        print(imageReport.imageSize)
        let comparison = imageReport.compare(against: referenceReport, comparing: .eyesCenters)
//        imageReport.describeComparison(against: referenceReport)

        let zoomed = image
            .zoomedPage1(by: Double(comparison.secondToFirstImageRatio))
            .ciImage
            .cropped(to: image.size.framed)

        let rotation = CGAffineTransform(
            translationX: image.size.width / 2,
            y: image.size.height / 2
        )
        .rotated(by: CGFloat(-comparison.secondToFirstAngleOffset.rads.value))
        .translatedBy(x: -image.size.width / 2, y: -image.size.height / 2)

        let zoomedAndRotated = zoomed
            .transformed(by: rotation)
            .cropped(to: image.size.framed)

        let translation = CGAffineTransform(
            translationX: -comparison.secondToFirstXOffset,
            y: -comparison.secondToFirstYOffset
        )

        return zoomedAndRotated
            .transformed(by: translation)
            .composited(over: referenceImage.ciImage)
            .cropped(to: referenceImage.size.framed)
            .nsImage(sized: referenceImage.size)
    }
}
