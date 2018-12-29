import AppKit
import Cocoa
import Quartz

public extension NSImage {

    public var cgImage: CGImage {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }

    public func jpgWrite(to url: URL, options: Data.WritingOptions = .atomic) throws {
        try data(ofType: .jpeg, compression: 0.3)?.write(to: url, options: options)
    }

    public func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) throws {
        try data(ofType: .png, compression: 0.3)?.write(to: url, options: options)
    }

    public func data(ofType type: NSBitmapImageRep.FileType, compression: Float = 1) -> Data? {

        guard let tiffRepresentation = tiffRepresentation,
            let bitmapImage = NSBitmapImageRep(data: tiffRepresentation)
        else {
            return nil
        }

        let pointsSize = bitmapImage.size
        let pixelSize = CGSize(width: bitmapImage.pixelsWide, height: bitmapImage.pixelsHigh)

        // https://stackoverflow.com/questions/8048597/how-to-change-image-resolution-in-objective-c
        var updatedPointsSize = pointsSize

        updatedPointsSize.width = ceil((72.0 * pixelSize.width) / 72);
        updatedPointsSize.height = ceil((72.0 * pixelSize.height) / 72);

        bitmapImage.size = updatedPointsSize

        return bitmapImage.representation(
            using: type,
            properties: [
                NSBitmapImageRep.PropertyKey.compressionFactor: compression,
            ]
        )
    }

    public func rotated(_ angle: Measurement<UnitAngle>) -> NSImage {

        var imageRect = CGRect(origin: .zero, size: size)

        let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)

        let imageRotator = IKImageView()

        let radsAngle = angle.converted(to: .radians)

        imageRotator.setImage(cgImage, imageProperties: [:])
        imageRotator.rotationAngle = CGFloat(radsAngle.value)

        let rotatedCGImage = imageRotator.image().takeUnretainedValue()

        let image = NSImage(cgImage: rotatedCGImage, size: imageRect.size)

        return image
    }
}
