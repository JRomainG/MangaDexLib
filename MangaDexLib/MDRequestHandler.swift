//
//  MDRequestHandler.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import WebKit

class MDRequestHandler: NSObject {

    /// User-Agent used for calls by this instance.
    /// During init, WKWebView is used to get the device's real User-Agent.
    /// The `MDApi.defaultUserAgent` string is then appended to that User-Agent
    private(set) var userAgent = MDApi.defaultUserAgent

    override init() {
        super.init()
        self.buildUserAgent(suffix: MDApi.defaultUserAgent)
    }

    /// Append the given suffix to the phone's default User-Agent
    /// - Parameter suffix: The string to append after the default User-Agent
    private func buildUserAgent(suffix: String) {
        WKWebView().evaluateJavaScript("navigator.userAgent") { (result, _) in
            if let userAgent = result as? String {
                self.setUserAgent(userAgent + suffix)
            } else {
                self.setUserAgent(suffix)
            }
        }
    }

    /// Change the User-Agent used for every API call
    /// - Parameter userAgent: The new user agent to use
    func setUserAgent(_ userAgent: String) {
        UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
    }

    /// Perform an async get request
    /// - Parameter url: The URL to fetch
    /// - Parameter completion: The callback at the end of the request
    func get(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: url)
        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { (data, _, error) in
            var output: String?
            if data != nil {
                output = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            }
            completion(output, error)
        }
        task.resume()
    }

}
