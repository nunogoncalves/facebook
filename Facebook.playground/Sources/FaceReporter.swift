import Foundation

public struct FaceReport {

    public let imageSize: CGSize
    public let leftEyePoints: [CGPoint]
    public let rightEyePoints: [CGPoint]

    public let eyesMiddlePoint: CGPoint

    public let leftPupilPoint: CGPoint
    public let rightPupilPoint: CGPoint

    public let pupilsMiddlePoint: CGPoint

    private let distanceBetweenEyesCentroid: CGFloat
    private let distanceBetweenEyesPupils: CGFloat

    public let eyesAngle: Measurement<UnitAngle>

    public var distanceBetweenEyes: CGFloat { return distanceBetweenEyesPupils }
}

public extension FaceReport {

    init(
        imageSize: CGSize,
        leftEyePoints: [CGPoint],
        rightEyePoints: [CGPoint],
        leftPupilPoint: CGPoint,
        rightPupilPoint: CGPoint
    ) {
        self.imageSize = imageSize

        self.leftEyePoints = leftEyePoints.apppendingFirst
        self.rightEyePoints = rightEyePoints.apppendingFirst

        self.leftPupilPoint = leftPupilPoint
        self.rightPupilPoint = rightPupilPoint

        let eyesLine = LineSegment(startPoint: leftPupilPoint, endPoint: rightPupilPoint)
        let angle = angleBetweenXAxis(and: eyesLine)
        self.eyesAngle = Measurement(value: Double(angle), unit: .degrees)

        self.eyesMiddlePoint = midPoint(between: leftEyePoints.centroid, and: rightEyePoints.centroid)
        self.pupilsMiddlePoint = midPoint(between: leftPupilPoint, and: rightPupilPoint)

        print("left pupil", leftPupilPoint, "right pupil", rightPupilPoint)
        self.distanceBetweenEyesPupils = distance(between: leftPupilPoint, and: rightPupilPoint)
        self.distanceBetweenEyesCentroid = distance(between: leftEyePoints.centroid, and: rightEyePoints.centroid)
    }
}

private extension Array where Element == CGPoint {

    var apppendingFirst: [CGPoint] {

        guard let first = self.first else { return self }

        var copy = self
        copy.append(first)
        return copy
    }
}

func percent(_ x: Any) -> String {
    return "\(x)%"
}

public extension FaceReport {

    var description: String {

        return """
        Pupils:
        Left: \(leftPupilPoint)
            relative to size: \(relativeToSize(leftPupilPoint)),
        Right: \(rightPupilPoint)/
            relative to size: \(percent(relativeToSize(rightPupilPoint))),
        Distance between pupils:
        x: \(rightPupilPoint.x - leftPupilPoint.x)
            relative to size: \((percent(((rightPupilPoint.x - leftPupilPoint.x) / imageSize.width).oneDecimal)))
        y: \(rightPupilPoint.y - leftPupilPoint.y)
        total: \(distanceBetweenEyesPupils),
        """
    }

    private func relativeToSize(_ point: CGPoint) -> (x: String, y: String) {

        return (
            x: percent((point.x / imageSize.width * 100).oneDecimal),
            y: percent((point.y / imageSize.height * 100).oneDecimal)
        )
    }
}

public extension FaceReport {

    func old_describeComparison(against anotherReport: FaceReport) {

        print("Center between eyes:")
        print("   reference: ", self.eyesMiddlePoint, "\n   against:   ", anotherReport.eyesMiddlePoint)
        print("   distance: x: ",
              self.eyesMiddlePoint.x - anotherReport.eyesMiddlePoint.x,
              " y: \(self.eyesMiddlePoint.y - anotherReport.eyesMiddlePoint.y)"
        )
        print("Angle difference: ", "\n   \(abs(self.eyesAngle.value - anotherReport.eyesAngle.value))")


        let dx = self.eyesMiddlePoint.x - anotherReport.eyesMiddlePoint.x
        let dy = self.eyesMiddlePoint.y - anotherReport.eyesMiddlePoint.y

        print("Eyes center difference: \n    x: \(dx), y: \(dy))")

        //        let eyesCentroidRatio = (self.distanceBetweenEyesCentroid / anotherReport.distanceBetweenEyesCentroid)
        let eyesPupulsRatio = (anotherReport.distanceBetweenEyesPupils / distanceBetweenEyesPupils)
        //        let distanceRatio = (eyesCentroidRatio + eyesPupulsRatio) / 2
        print("Against image's size is \(eyesPupulsRatio * 100) % of the first")
    }

    func describeComparison(against otherReport: FaceReport) {
        //
        //        let wDelta = (self.imageSize.width - otherReport.imageSize.width) / 2
        //        let hDelta = (self.imageSize.height - otherReport.imageSize.height) / 2
        //
        //        let againstLeftPupil = CGPoint(x: otherReport.leftPupilPoint.x + wDelta, y: otherReport.leftPupilPoint.y + hDelta)
        //        let againstRightPupil = CGPoint(x: otherReport.rightPupilPoint.x + wDelta, y: otherReport.rightPupilPoint.y + hDelta)
        //        let againstEyesCenter = CGPoint(x: otherReport.eyesMiddlePoint.x + wDelta, y: otherReport.eyesMiddlePoint.y + hDelta)

        print("eyes center point:")
        print("     first:", self.eyesMiddlePoint)
        print("   against:", otherReport.eyesMiddlePoint)
        print("      dx: \(self.eyesMiddlePoint.x - otherReport.eyesMiddlePoint.x)")
        print("      dy: \(self.eyesMiddlePoint.y - otherReport.eyesMiddlePoint.y)")

        print("left pupil eye:")
        print("     first:", self.leftPupilPoint)
        print("   against:", otherReport.leftPupilPoint)
        print("      dx: \(self.leftPupilPoint.x - otherReport.leftPupilPoint.x)")
        print("      dy: \(self.leftPupilPoint.y - otherReport.leftPupilPoint.y)")

        print("right pupil eye:")
        print("     first:", self.rightPupilPoint)
        print("   against:", otherReport.rightPupilPoint)
        print("      dx: \(self.rightPupilPoint.x - otherReport.rightPupilPoint.x)")
        print("      dy: \(self.rightPupilPoint.y - otherReport.rightPupilPoint.y)")

        print("distance between pupils")
        print("     first:", self.distanceBetweenEyesPupils)
        print("   against:", otherReport.distanceBetweenEyesPupils)

        let eyesPupilsRatio = (otherReport.distanceBetweenEyesPupils / self.distanceBetweenEyesPupils)
        print("Against image's size is \(eyesPupilsRatio * 100) % of the first (using pupils)")

        let eyesCentroidsRatio = (otherReport.distanceBetweenEyesCentroid / self.distanceBetweenEyesCentroid)
        print("Against image's size is \(eyesCentroidsRatio * 100) % of the first (using centroids)")

        print("Angle difference: ", "\n   \(abs(self.eyesAngle.value - otherReport.eyesAngle.value))")
    }

    func compare(
        against otherReport: FaceReport,
        comparing eyesDistanceType: ImageReportComparison.ComparisonType
    ) -> ImageReportComparison {

        let eyesPupulsRatio: CGFloat

        if eyesDistanceType == .pupils {

            eyesPupulsRatio = (otherReport.distanceBetweenEyesPupils / distanceBetweenEyesPupils)
        } else {

            eyesPupulsRatio = (otherReport.distanceBetweenEyesCentroid / distanceBetweenEyesCentroid)
        }

        let againstLeftPupil = CGPoint(x: otherReport.leftPupilPoint.x, y: otherReport.leftPupilPoint.y)

        let dx = self.leftPupilPoint.x - againstLeftPupil.x
        let dy = self.leftPupilPoint.y - againstLeftPupil.y

        let angleOffset = self.eyesAngle.value - otherReport.eyesAngle.value

        return ImageReportComparison(
            comparing: eyesDistanceType,
            secondToFirstImageRatio: eyesPupulsRatio,
            secondToFirstAngleOffset: Measurement(value: angleOffset, unit: .degrees),
            secondToFirstXOffset: dx,
            secondToFirstYOffset: dy
        )
    }
}

public struct ImageReportComparison {

    public enum ComparisonType {

        case pupils
        case eyesCenters
    }

    public let comparing: ComparisonType
    public let secondToFirstImageRatio: CGFloat
    public let secondToFirstAngleOffset: Measurement<UnitAngle>
    public let secondToFirstXOffset: CGFloat
    public let secondToFirstYOffset: CGFloat
}
