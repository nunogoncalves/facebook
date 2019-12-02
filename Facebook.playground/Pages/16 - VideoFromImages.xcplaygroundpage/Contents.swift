import AVFoundation
import AppKit
import Photos
import AVKit

//class VideoMakerViewController: UIViewController {
//
//var images:[NSImage]=[]
//@IBOutlet weak var videoview: UIView!
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    DispatchQueue.main.async {
//        let settings = RenderSettings()
//        let imageAnimator = ImageAnimator(renderSettings: settings,imagearr: self.images)
//        imageAnimator.render() {
//            self.displayVideo()
//        }
//    }
//}
//
//func displayVideo()
//{
//
//    let u:String=tempurl
//    let player = AVPlayer(url: URL(fileURLWithPath: u))
//    let playerController = AVPlayerViewController()
//    playerController.player = player
//    self.addChild(playerController)
//    videoview.addSubview(playerController.view)
//    playerController.view.frame.size=(videoview.frame.size)
//    playerController.view.contentMode = .scaleAspectFit
//    playerController.view.backgroundColor=UIColor.clear
//    videoview.backgroundColor=UIColor.clear
//    player.play()
//}
//
//@IBAction func save(_ sender: UIBarButtonItem) {
//    PHPhotoLibrary.requestAuthorization { status in
//        guard status == .authorized else { return }
//
//        let u:String=tempurl
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: u) as URL)
//        }) { success, error in
//            if !success {
//                print("Could not save video to photo library:", error!)
//            }
//        }
//    }
//}
//
//
//}

struct RenderSettings {

    let size: CGSize
    let videoName: String
    let outputURL: URL

    let fps: Int32 = 15
    let avCodecKey = AVVideoCodecType.h264
    let videoFilenameExt = "mp4"
}

class VideoWriter {

    let renderSettings: RenderSettings

    var videoWriter: AVAssetWriter!
    var videoWriterInput: AVAssetWriterInput!
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!

    var isReadyForData: Bool {
        return videoWriterInput?.isReadyForMoreMediaData ?? false
    }

    class func pixelBufferFromImage(
        image: NSImage,
        pixelBufferPool: CVPixelBufferPool,
        size: CGSize
    ) -> CVPixelBuffer {

        var pixelBufferOut: CVPixelBuffer?

        let status = CVPixelBufferPoolCreatePixelBuffer(
            kCFAllocatorDefault,
            pixelBufferPool,
            &pixelBufferOut
        )

        if status != kCVReturnSuccess {
            fatalError("CVPixelBufferPoolCreatePixelBuffer() failed")
        }

        let pixelBuffer = pixelBufferOut!

        CVPixelBufferLockBaseAddress(pixelBuffer, [])

        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: data,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )

        context!.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let horizontalRatio = size.width / image.size.width
        let verticalRatio = size.height / image.size.height

        let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit

        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)

        let x = newSize.width < size.width ? (size.width - newSize.width) / 2 : 0
        let y = newSize.height < size.height ? (size.height - newSize.height) / 2 : 0

        context!.concatenate(CGAffineTransform.identity)
        context!.draw(
            image.cgImage,
            in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height)
        )

        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])

        return pixelBuffer
    }

    init(renderSettings: RenderSettings) {
        self.renderSettings = renderSettings
    }

    func start() {

        let avOutputSettings: [String: AnyObject] = [
            AVVideoCodecKey: renderSettings.avCodecKey as AnyObject,
            AVVideoWidthKey: NSNumber(value: Float(renderSettings.size.width)),
            AVVideoHeightKey: NSNumber(value: Float(renderSettings.size.height))
        ]

        func createPixelBufferAdaptor() {
            let sourcePixelBufferAttributesDictionary = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(renderSettings.size.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(renderSettings.size.height))
            ]
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: videoWriterInput,
                sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary
            )
        }

        func createAssetWriter(outputURL: URL) -> AVAssetWriter {
            guard let assetWriter = try? AVAssetWriter(outputURL: outputURL as URL, fileType: AVFileType.mp4) else {
                fatalError("AVAssetWriter() failed")
            }

            guard assetWriter.canApply(outputSettings: avOutputSettings, forMediaType: AVMediaType.video) else {
                fatalError("canApplyOutputSettings() failed")
            }

            return assetWriter
        }

        videoWriter = createAssetWriter(outputURL: renderSettings.outputURL)
        videoWriterInput = AVAssetWriterInput(
            mediaType: AVMediaType.video,
            outputSettings: avOutputSettings
        )

        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        }
        else {
            fatalError("canAddInput() returned false")
        }


        createPixelBufferAdaptor()

        if videoWriter.startWriting() == false {
            fatalError("startWriting() failed")
        }

        videoWriter.startSession(atSourceTime: CMTime.zero)

        precondition(pixelBufferAdaptor.pixelBufferPool != nil, "nil pixelBufferPool")
    }

    func render(appendPixelBuffers: @escaping (VideoWriter) -> Bool, completion: @escaping () -> Void) {

        precondition(videoWriter != nil, "Call start() to initialze the writer")

        let queue = DispatchQueue(label: "mediaInputQueue")
        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            let isFinished = appendPixelBuffers(self)
            if isFinished {
                self.videoWriterInput.markAsFinished()
                self.videoWriter.finishWriting() {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
            else {

            }
        }
    }

    func addImage(image: NSImage, withPresentationTime presentationTime: CMTime) -> Bool {

        precondition(pixelBufferAdaptor != nil, "Call start() to initialze the writer")

        let pixelBuffer = VideoWriter.pixelBufferFromImage(
            image: image,
            pixelBufferPool: pixelBufferAdaptor.pixelBufferPool!,
            size: renderSettings.size
        )
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }

}

class ImageAnimator{

    static let kTimescale: Int32 = 600

    let settings: RenderSettings
    let videoWriter: VideoWriter
    var images: [NSImage]!

    var frameNum = 0

    class func removeFileAtURL(fileURL: NSURL) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path!)
        }
        catch _ as NSError {
            //
        }
    }

    init(renderSettings: RenderSettings, images: [NSImage]) {
        settings = renderSettings
        videoWriter = VideoWriter(renderSettings: settings)
        images = images
    }

    func render(completion: @escaping () -> Void) {

        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
//        ImageAnimator.removeFileAtURL(fileURL: settings.outputURL)

        videoWriter.start()
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) {
            completion()
        }

    }


    func appendPixelBuffers(writer: VideoWriter) -> Bool {

        let frameDuration = CMTimeMake(value: Int64(ImageAnimator.kTimescale / settings.fps), timescale: ImageAnimator.kTimescale)

        while !images.isEmpty {

            if writer.isReadyForData == false {

                return false
            }

            let image = images.removeFirst()
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = videoWriter.addImage(image: image, withPresentationTime: presentationTime)
            if success == false {
                fatalError("addImage() failed")
            }

            frameNum=frameNum+1
        }


        return true
    }

}

let images = FileManager.default
    .images(in: playgroundDirectory.appendingPathComponent("sourceImagesNuno"))
    .sorted(by: \.lastPathComponent)
    .map { NSImage(contentsOf: $0)! }

let settings = RenderSettings(
    size: CGSize(width: 4032, height: 3024),
    videoName: "Nuno",
    outputURL: playgroundDirectory.appendingPathComponent("resultNunoVideo")
)

ImageAnimator(renderSettings: settings,imagearr: images).render {

}

