//
//  ExtNetworking.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/05.
//

import Foundation
import Alamofire

final class EventMonitor: Alamofire.EventMonitor {
    internal let queue = DispatchQueue(label: "NetworkingLogger")
    private let tag = "API"
    private let logStringLengthLimit = 524288
    
    func requestDidResume(_ request: Request) {
        var msgs: [String] = ["\(request)"]
        let headers = request.request?.allHTTPHeaderFields.map { $0.description }
        if var str = headers, !str.isEmpty {
            msgs.append("Headers:")
            if str.count > logStringLengthLimit {
                str = str.substring(to: logStringLengthLimit) + "..."
            }
            msgs.append("    " + str)
        }
        
        let body = request.request?.httpBody?.uniCodeToStr
        if var str = body, !str.isEmpty {
            msgs.append("body:")
            if str.count > logStringLengthLimit {
                str = str.substring(to: logStringLengthLimit) + "..."
            }
            msgs.append("    " + str)
        }
        print(tag, "➡️", msgs.joined(separator: "\n"))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        var str = response.data?.uniCodeToStr ?? ""
        if str.count > logStringLengthLimit {
            str = str.substring(to: logStringLengthLimit) + "..."
        }
        let msgs: [String] = [
            "\(request)",
            "    " + str
        ]
        print(tag, "⬅️", msgs.joined(separator: "\n"))
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print(tag, "❗️❗️❗️", error.localizedDescription)
    }
    
    func request(_ request: Request, didCompleteTask task: URLSessionTask, with error: AFError?) {
        guard let error = error else { return }
        print(tag, "❗️❗️❗️", error.localizedDescription)
    }
}
extension String {
    func substring(to: Int) -> String {
        let toIndex = utf16.index(startIndex, offsetBy: to)
        return String(self[..<toIndex])
    }
}
extension Data {
    var uniCodeToStr: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let uniCodeToStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return uniCodeToStr as String
    }
}
