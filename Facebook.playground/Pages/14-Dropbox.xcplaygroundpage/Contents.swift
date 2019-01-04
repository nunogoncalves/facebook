import Foundation
import PlaygroundSupport


class Uploader: NSObject, URLSessionDataDelegate {

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        print("sent", Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100)
    }
}
let up = Uploader()

let data = refImage.data(ofType: .jpeg)

let url = URL(string: "https://content.dropboxapi.com/2/files/upload")!
var request = URLRequest(url: url)
request.httpMethod = "POST"

let json: [String: Any] = [
    "path": "/dailyself/Inês/Selected/me.jpeg",
    "mode": "add",
    "mute": false,
    "autorename": false,
    "strict_conflict": false
]

let d = try! JSONSerialization.data(withJSONObject: json, options: [])
let string = String(data: d, encoding: .isoLatin1)!

request.addValue(string, forHTTPHeaderField: "Dropbox-API-Arg")
request.addValue("Bearer <token>", forHTTPHeaderField: "Authorization")
request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

let session = URLSession(configuration: .default, delegate: up, delegateQueue: nil)
print(request.allHTTPHeaderFields)

session.uploadTask(with: request, from: data) { (data, response, error) in

    print(String(data: data!, encoding: .utf8))
    print(try? JSONSerialization.jsonObject(with: data!, options: [.mutableLeaves]))
}.resume()


