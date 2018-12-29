import Vision

public extension VNFaceObservation {

    public enum Side {
        case left
        case right
    }

    public enum FaceOrganType {
        case eye
        case pupil
    }

    public var leftEye: VNFaceLandmarkRegion2D? { return self.landmarks?.leftEye }
    public var rightEye: VNFaceLandmarkRegion2D? { return self.landmarks?.rightEye}
    public var leftPupil: VNFaceLandmarkRegion2D? { return self.landmarks?.leftPupil }
    public var rightPupil: VNFaceLandmarkRegion2D? { return self.landmarks?.rightPupil }

    func points(for side: Side, _ type: FaceOrganType, within size: NSSize) -> [CGPoint] {

        switch type {

        case .eye:
            switch side {
            case .left: return leftEye?.pointsInImage(imageSize: size) ?? []
            case .right: return rightEye?.pointsInImage(imageSize: size) ?? []
            }

        case .pupil:
            switch side {
            case .left: return leftPupil?.pointsInImage(imageSize: size) ?? []
            case .right: return rightPupil?.pointsInImage(imageSize: size) ?? []
            }
        }
    }
}

