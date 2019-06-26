import Vision

public extension VNFaceObservation {

    enum Side {
        case left
        case right
    }

    enum FaceOrganType {
        case eye
        case pupil
    }

    var leftEye: VNFaceLandmarkRegion2D? { return self.landmarks?.leftEye }
    var rightEye: VNFaceLandmarkRegion2D? { return self.landmarks?.rightEye}
    var leftPupil: VNFaceLandmarkRegion2D? { return self.landmarks?.leftPupil }
    var rightPupil: VNFaceLandmarkRegion2D? { return self.landmarks?.rightPupil }

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

