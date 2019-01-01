import Foundation
import Cocoa

public struct Processor {

    private let referenceImage: NSImage
    private let referenceCIImage: CIImage
    private var referenceReport: FaceReport!
    private let referenceSize: CGSize

    public init(referenceImage: NSImage) {
        self.referenceImage = referenceImage
        self.referenceCIImage = referenceImage.ciImage
        self.referenceSize = referenceImage.size

        var refReport: FaceReport!
        _ = Analyser(image: refImage) { refReport = $0 }
        self.referenceReport = refReport
    }

    public func processed(_ image: NSImage) -> NSImage {

        let resizedImage = image.resizeMaintainingAspectRatio(to: referenceSize)!

        var result: NSImage!

        _ = Analyser(image: resizedImage) { imageReport in

            let comparison = imageReport.compare(against: self.referenceReport, comparing: .pupils)

            var resizedAndZoomed = resizedImage
                .zoomedPage1(by: Double(comparison.secondToFirstImageRatio))
                .ciImage
                .composited(over: self.referenceCIImage.blurred(withRadius: 20))
                .cropped(to: self.referenceSize.framed)

            let rotation = CGAffineTransform(
                    translationX: self.referenceSize.width / 2,
                    y: self.referenceSize.height / 2
                )
                .rotated(by: CGFloat(comparison.secondToFirstAngleOffset.rads.value))
                .translatedBy(x: -self.referenceSize.width / 2, y: -self.referenceSize.height / 2)

            resizedAndZoomed = resizedAndZoomed
                .transformed(by: rotation)
                .composited(over: self.referenceCIImage)
                .cropped(to: self.referenceSize.framed)

            let resizedZoomedImage = resizedAndZoomed.nsImage(sized: self.referenceSize)

            _ = Analyser(image: resizedZoomedImage, imageSize: self.referenceSize) { resizedZoomedReport in

                let zoomComparison = resizedZoomedReport.compare(against: self.referenceReport, comparing: .pupils)

                let blur = resizedAndZoomed
                    .blurred(withRadius: 20)
                    .cropped(to: self.referenceCIImage.extent)

                let translation = CGAffineTransform(
                    translationX: -zoomComparison.secondToFirstXOffset,
                    y: -zoomComparison.secondToFirstYOffset
                )

                result = resizedAndZoomed
                    .transformed(by: translation)
                    .composited(over: blur)
                    .cropped(to: self.referenceSize.framed)
                    .nsImage(sized: resizedAndZoomed.extent.size)
            }
        }
        return result
    }
}
