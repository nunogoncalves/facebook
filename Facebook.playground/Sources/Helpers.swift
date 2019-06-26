import Foundation
import Cocoa

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

    var oneDecimal: CGFloat {

        return (self * 100).rounded() / 100
    }
}

public extension Double {

    var oneDecimal: Double {

        return (self * 100).rounded() / 100
    }
}


public extension Int {

    var degrees: Measurement<UnitAngle> {

        return Double(self).degrees
    }
}

public extension Double {

    var degrees: Measurement<UnitAngle> {

        return Measurement(value: self, unit: .degrees)
    }
}

public extension Measurement where UnitType == UnitAngle {

    var rads: Measurement<UnitAngle> {

        return self.converted(to: .radians)
    }
}

public extension CGSize {

    func rotated(_ degrees: Measurement<UnitAngle>) -> CGSize {

        //Use math instead of importing AppKit for these calculations
        let view = NSView(frame: CGRect(origin: .zero, size: self))
        view.rotate(byDegrees: CGFloat(degrees.value))
        return view.bounds.size
    }

    func times(_ multiplier: Double) -> CGSize {
        return CGSize(width: width * CGFloat(multiplier), height: height * CGFloat(multiplier))
    }

    func devided(_ multiplier: CGFloat) -> CGSize {
        return CGSize(width: width / CGFloat(multiplier), height: height / CGFloat(multiplier))
    }

    var framed: CGRect { return CGRect(origin: .zero, size: self) }
}

public extension CGAffineTransform {
    init(rotationDegrees degrees: Measurement<UnitAngle>) {
        self.init(rotationAngle: CGFloat(degrees.rads.value))
    }
}

public extension CGRect {

    var center: CGPoint {

        return CGPoint(x: width / 2, y: height / 2)
    }
}

public extension Array {

    ///Implementation defaults to ascending (<=)
    func sorted<PropertyType: Comparable>(
        by keyPath: KeyPath<Element, PropertyType>,
        comparison: (PropertyType, PropertyType) -> Bool = { $0 <= $1 }
    ) -> Array {

        return sorted { comparison($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
}
