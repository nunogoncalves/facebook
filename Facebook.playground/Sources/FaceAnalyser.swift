import Vision

public protocol FaceAnalyserDelegate: class {

    func completed(_ report: FaceReport, for image: CGImage)
}

final public class FaceAnalyser {

    private let image: CGImage
    private let imageSize: CGSize

    private var faceLandmarksRequest: VNDetectFaceLandmarksRequest!

    var report: FaceReport?

    public weak var delegate: FaceAnalyserDelegate?

    public init(image: CGImage, ofSize size: CGSize) {

        self.image = image
        self.imageSize = size

        self.faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceDetection)
    }

    private func handleFaceDetection(_ request: VNRequest, error: Error?) {

        guard error == nil else { print("Error analysing image"); return }

        guard let results = request.results as? [VNFaceObservation] else {
            print("results not of type [VNFaceObservation]")
            return
        }

        guard !results.isEmpty else { print("no results"); return }

        let reports: [FaceReport] = results.map { faceObservation in

            let leftEyesPoints = faceObservation.points(for: .left, .eye, within: imageSize)
            let rightEyesPoints = faceObservation.points(for: .right, .eye, within: imageSize)

            let leftEyePupil = faceObservation.points(for: .left, .pupil, within: imageSize).first!
            let rightEyePupil = faceObservation.points(for: .right, .pupil, within: imageSize).first!

            return FaceReport(
                imageSize: imageSize,
                leftEyePoints: leftEyesPoints,
                rightEyePoints: rightEyesPoints,
                leftPupilPoint: leftEyePupil,
                rightPupilPoint: rightEyePupil
            )
        }

        let report = reports.max { $0.distanceBetweenEyes <= $1.distanceBetweenEyes }

        self.delegate?.completed(report!, for: image)
    }

    public func start() {

        let imageRequestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        try? imageRequestHandler.perform([self.faceLandmarksRequest])
    }
}
