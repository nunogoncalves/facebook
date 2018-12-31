import AppKit
import Cocoa
import Quartz

public extension NSImage {

    public var cgImage: CGImage {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }

    public var ciImage: CIImage { return CIImage(data: tiffRepresentation!)! }

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

    public func rotatedUsingIKImageView(_ angle: Measurement<UnitAngle>) -> NSImage {

        var imageRect = CGRect(origin: .zero, size: size)

        let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)

        let imageRotator = IKImageView()

        let radsAngle = angle.converted(to: .radians)

        imageRotator.setImage(cgImage, imageProperties: [:])
        imageRotator.rotationAngle = CGFloat(radsAngle.value)

        let rotatedCGImage = imageRotator.image().takeUnretainedValue()

        let image = NSImage(cgImage: rotatedCGImage, size: imageRect.size)
        print(image.size)

        return image
    }

    public func rotatedUsingCIImage(_ degrees: Measurement<UnitAngle>) -> NSImage? {

        let ciImage = CIImage(data: self.tiffRepresentation!)!
        //https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIStraightenFilter
        let rotated = ciImage.applyingFilter(
            "CIStraightenFilter",
            parameters: [kCIInputAngleKey: degrees.rads]
        )
        print(rotated.extent)

        let representation = NSCIImageRep(ciImage: rotated)
        print(representation.size)
        let nsImage = NSImage(size: representation.size)
        nsImage.addRepresentation(representation)

        return nsImage
    }

    public func zoomedPage1(by zoom: Double) -> NSImage {

        let cgFloatZoom = CGFloat(zoom)
        let frame = size.times(zoom).framed
        let dx: CGFloat = (size.width - ((size.width * cgFloatZoom))) / 2
        let dy: CGFloat = (size.height - ((size.height * cgFloatZoom))) / 2

        return NSImage(size: size, flipped: false) { _ in

            return self.bestRepresentation(
                for: .zero,
                context: nil,
                hints: nil
            )!
            .draw(in: frame.offsetBy(dx: dx, dy: dy))
        }
    }

    public func resized(to targetSize: NSSize) -> NSImage? {

        let frame = NSRect(origin: .zero, size: targetSize)

        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize, flipped: false) { _ in
            return representation.draw(in: frame)
        }
        return image
    }

    public func resizeMaintainingAspectRatio(to targetSize: NSSize) -> NSImage? {

        let testSize = self.size

        let testRatio = testSize.width / testSize.height

        let newTestSize = CGSize(width: targetSize.height * testRatio, height: targetSize.height)
        return self.resized(to: newTestSize)
    }
}

public extension CIImage {

    public func nsImage(sized size: CGSize) -> NSImage {

        let representation = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: size.devided(2))
        nsImage.addRepresentation(representation)
        return nsImage
    }

    public func blurred(withRadius radius: Int) -> CIImage {

        return applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: radius])
    }
}
