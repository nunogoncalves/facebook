import Foundation

public struct LineSegment {
    public let startPoint: CGPoint
    public let endPoint: CGPoint
}

public func angleBetweenXAxis(and line: LineSegment) -> CGFloat {

    let p1 = line.startPoint
    let p2 = line.endPoint

    let dy = p2.y - p1.y
    let dx = p2.x - p1.x

    return (atan(dy / dx) * 180) / .pi
}

public func midPoint(between left: CGPoint, and right: CGPoint) -> CGPoint {

    return CGPoint(
        x: (left.x + right.x) / 2,
        y: (left.y + right.y) / 2
    )
}

public func distance(between a: CGPoint, and b: CGPoint) -> CGFloat {

    let xDist = a.x - b.x
    let yDist = a.y - b.y

    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
}

public extension CGPoint {

    static func -(l: CGPoint, r: CGPoint) -> CGPoint {

        let dX = l.x - r.x
        let dY = l.y - r.y

        return CGPoint(x: dX, y: dY)
    }

    static func angleBetweenXAxis(point1 p1: CGPoint, and p2: CGPoint) -> CGFloat {

        let dy = p2.y - p1.y
        let dx = p2.x - p1.x

        return (atan(dy / dx) * 180) / .pi
    }
}

public extension CGFloat {

    public var oneDecimal: CGFloat {

        return (self * 100).rounded() / 100
    }
}
