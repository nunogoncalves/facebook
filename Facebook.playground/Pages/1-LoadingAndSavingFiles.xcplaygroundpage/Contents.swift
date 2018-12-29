import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)

let refImageURL = imagesUrls.first { $0.lastPathComponent == "reference.jpg" }!
let refImage = NSImage(contentsOf: refImageURL)!

let refImageJPGURL = URL(fileURLWithPath: "referenceCreated.jpg", relativeTo: playgroundDirectory)
try save(refImage, to: refImageJPGURL)
