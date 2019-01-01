import AppKit

var str = "1535"

public func image(with number: Int) {

    let size = CGSize(width: 120, height: 40)

    let textView = NSTextView(frame: CGRect(origin: .zero, size: size))
    textView.string = "\(number)"
    textView.alignment = .right
    textView.textStorage?.font = NSFont.systemFont(ofSize: 40)

    textView.setTextColor(.white, range: NSRange(location: 0, length: textView.textStorage!.length))

    let bi = textView.bitmapImageRepForCachingDisplay(in: size.framed)!
    bi.size = size
    textView.cacheDisplay(in: size.framed, to: bi)

    let nsImage = NSImage(size: size)
    nsImage.addRepresentation(bi)
    nsImage
}

