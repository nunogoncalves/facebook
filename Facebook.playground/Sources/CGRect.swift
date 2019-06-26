import Foundation

public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

    func centered(in destRect: CGRect) -> CGRect {
        let dx = self.center.x - destRect.center.x
        let dy = self.center.y - destRect.center.y
        return offsetBy(dx: -dx, dy: -dy)
    }
}
