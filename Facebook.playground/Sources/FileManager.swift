import Foundation
import Cocoa

public let playgroundDirectory = Bundle.main.url(forResource: "token", withExtension: "txt")!
    .resolvingSymlinksInPath()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

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

public func save(_ image: NSImage, to url: URL) throws {
    try image.data(ofType: .jpeg, compression: 0.3)?.write(to: url, options: .atomic)
}
