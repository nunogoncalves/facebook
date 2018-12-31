import Foundation
import Cocoa
import AppKit

let overlapURL = playgroundDirectory.appendingPathComponent("overlap/?")

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
let testingImageURL = imagesUrls.first { $0.lastPathComponent.starts(with: "testImage") }!
let testingImage = NSImage(contentsOf: testingImageURL)!

let testResized = testingImage.resizeMaintainingAspectRatio(to: refImage.size)!

let ciRefImage = refImage.ciImage
let size = refImage.size


_ = Analyser(image: refImage) { refReport in

    _ = Analyser(image: testResized) { testingReport in

        let comparison = testingReport.compare(against: refReport, comparing: .pupils)

        var testResizedZoomed = testResized.zoomedPage1(by: Double(comparison.secondToFirstImageRatio)).ciImage
        testResizedZoomed = testResizedZoomed.composited(over: ciRefImage).cropped(to: size.framed)

        let rotation = CGAffineTransform(translationX: size.width / 2, y: size.height / 2)
            .rotated(by: CGFloat(comparison.secondToFirstAngleOffset.rads.value))
            .translatedBy(x: -size.width / 2, y: -size.height / 2)

        testResizedZoomed = testResizedZoomed
            .transformed(by: rotation)
            .composited(over: ciRefImage)
            .cropped(to: size.framed)

        let testResizedZoomedImage = testResizedZoomed.nsImage(sized: size)

        _ = Analyser(image: testResizedZoomedImage, imageSize: size) { testResizedZoomReport in

            let zoomComparison = testResizedZoomReport.compare(against: refReport, comparing: .pupils)

            let blur = testResizedZoomed
                .blurred(withRadius: 20).cropped(to: ciRefImage.extent)

            let translation = CGAffineTransform(
                translationX: -zoomComparison.secondToFirstXOffset,
                y: -zoomComparison.secondToFirstYOffset
            )

            var offsetResult = testResizedZoomed
                .transformed(by: translation)
                .composited(over: blur)
                .cropped(to: size.framed)

            try! save(offsetResult, to: overlapURL.appending(name: "result.jpg"))
        }
    }
}
