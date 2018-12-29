import Foundation
import AppKit

public class Analyser: FaceAnalyserDelegate {

    let callback: (FaceReport) -> ()
    let faceAnalyser: FaceAnalyser

    public init(image: NSImage, imageSize: CGSize? = nil, callback: @escaping (FaceReport) -> ()) {

        self.callback = callback

        faceAnalyser = FaceAnalyser(image: image.cgImage, ofSize: imageSize ?? image.size)
        faceAnalyser.delegate = self

        faceAnalyser.start()
    }

    public func completed(_ report: FaceReport, for image: CGImage) {

        callback(report)
    }
}
