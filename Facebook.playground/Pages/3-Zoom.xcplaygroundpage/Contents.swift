import Foundation
import Cocoa
import AppKit

let imagesUrls = FileManager.default.images(in: playgroundDirectory)
var zoomUrl = playgroundDirectory
zoomUrl.appendPathComponent("zoom/?")

for i in 0...20 {

    let zoom = Double(Float(i) / 10).oneDecimal
    let zoomedImage = refImage.zoomedPage1(by: zoom)
    let zoomedImageURL = URL(fileURLWithPath: "\(zoom)-zoom.jpg", relativeTo: zoomUrl)
    print(zoomedImageURL)
    try save(zoomedImage, to: zoomedImageURL)
}
