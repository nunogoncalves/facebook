import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
var croppedUrl = playgroundDirectory
croppedUrl.appendPathComponent("crop/?")

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let refImage = NSImage(contentsOf: refImageURL)!

extension NSImage {

    func croped(in frame: CGRect) -> NSImage? {

        //https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
        return NSImage(cgImage: self.cgImage.cropping(to: frame)!, size: frame.size)
    }
}

let size = refImage.size
let toCropFrame = CGRect(x: 200, y: 200, width: 2000, height: 1500)
let croppedImage = refImage.croped(in: toCropFrame)!

let croppedImageURL = URL(fileURLWithPath: "croppedReference-2000x1500.jpg", relativeTo: croppedUrl)
try save(croppedImage, to: croppedImageURL)

