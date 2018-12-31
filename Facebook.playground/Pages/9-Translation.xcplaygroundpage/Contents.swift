import Cocoa

var translationUrl = playgroundDirectory
translationUrl.appendPathComponent("translation/?")

let ciImage = CIImage(data: refImage.tiffRepresentation!)!
let size = refImage.size

let blur = ciImage.blurred(withRadius: 20).cropped(to: ciImage.extent)

let translation = CGAffineTransform(translationX: size.width / 2, y: size.height / 2)

let rotatedCI = ciImage.transformed(by: translation)
let rotatedResult = rotatedCI.composited(over: blur).cropped(to: size.framed)

//let translated = ciImage.transformed(by: translation).nsImage(sized: size)
try save(rotatedResult, to: translationUrl.appending(name: "translated.jpg"))
