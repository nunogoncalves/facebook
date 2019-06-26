import Cocoa

public extension Array where Element == CGPoint {

    var bezierPath: NSBezierPath {

        let bezierPath = NSBezierPath()

        guard self.isEmpty == false else { return bezierPath }

        bezierPath.move(to: self.first!)

        guard self.first != self.last else {

            bezierPath.close()
            return bezierPath
        }

        let withoutEdges = self.dropFirst()

        Array(withoutEdges).forEach { bezierPath.line(to: $0) }

        bezierPath.line(to: self.last!)
        bezierPath.close()

        return bezierPath
    }

    private var area: CGFloat {

        var sum: CGFloat = 0

        for i in (0...count - 2) {

            let xi = self[i].x
            let xi1 = self[i+1].x

            let yi = self[i].y
            let yi1 = self[i+1].y

            sum += ((xi * yi1) - (xi1 * yi))
        }

        return sum / 2
    }

    var centroid: CGPoint {

        let _area = self.area

        var sumX: CGFloat = 0
        var sumY: CGFloat = 0

        //sumX
        for i in (0...count - 2) {

            let xi = self[i].x
            let xi1 = self[i+1].x

            let yi = self[i].y
            let yi1 = self[i+1].y

            sumX += ((xi + xi1) * ((xi * yi1) - (xi1 * yi)))
            sumY += ((yi + yi1) * ((xi * yi1) - (xi1 * yi)))
        }

        let cx = (1 / (6 * _area)) * sumX
        let cy = (1 / (6 * _area)) * sumY

        return CGPoint(x: cx, y: cy)
    }
}
