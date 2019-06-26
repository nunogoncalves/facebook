import Foundation
import Cocoa

public enum Person: String {
    case alice = "Alice"
    case Bianca = "Bianca"
    case katrina = "Katrina"
    case nuno = "Nuno"
}

public let playgroundDirectory = Bundle.main.url(forResource: "token", withExtension: "txt")!
    .resolvingSymlinksInPath()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

public let refImage = NSImage(
    contentsOf: FileManager.default
        .images(in: playgroundDirectory)
        .first { $0.lastPathComponent == "reference.jpg" }!
)!

public func refImage(for person: Person) -> NSImage {
    return NSImage(
        contentsOf: FileManager.default
        .images(in: playgroundDirectory)
        .first { $0.lastPathComponent == "reference\(person.rawValue).jpg" }!
    )!
}


extension FileManager {

    public func files(in url: URL) -> [URL] {
        do {
            return try contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            return []
        }
    }

    private static let imageFormats = ["png", "jpg", "jpeg", "heic"]

    public func images(in url: URL) -> [URL] {
        return files(in: url).filter { FileManager.imageFormats.contains($0.pathExtension.lowercased()) }
    }
}

public func save(_ image: NSImage, to url: URL, compression: Float = 0.3) throws {

    let path = url.deletingLastPathComponent()

    if !FileManager.default.fileExists(atPath: path.absoluteString) {
        try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }

    try image.data(ofType: .jpeg, compression: compression)?.write(to: url, options: .atomic)
}

public func save(_ ciImage: CIImage, to url: URL, compression: Float = 0.3) throws {
    try save(ciImage.nsImage(sized: ciImage.extent.size), to: url, compression: compression)
}

public extension URL {

    func appending(name: String) -> URL {

        return URL(fileURLWithPath: name, relativeTo: self)
    }
}
