//
//  MDRequestHandler.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import WebKit

/// The class responsible for performing requests
class MDRequestHandler: NSObject {

    /// The different types of cookies that can be changed by the API
    enum CookieType: String {
        case ratedFilter = "mangadex_h_toggle"
        case authToken = "mangadex_rememberme_token"
        case sessionId = "mangadex_session"
        case ddosGuard = "__ddg1"
    }

    /// The different fields set for POST requests to login
    enum AuthField: String {
        case username = "login_username"
        case password = "login_password"
        case twoFactor = "two_factor"
        case remember = "remember_me"
    }

    /// The different ways of encoding the data for POST requests
    enum BodyEncoding {
        case multipart
        case urlencoded
    }

    /// An alias for the completion blocks called after requests
    typealias RequestCompletion = (String?, Error?) -> Void

    /// Domain used by MangaDex to set cookies
    static let cookieDomain: String = ".mangadex.org"

    /// Path used by MangaDex to set cookies
    static let cookiePath: String = "/"

    /// User-Agent used for calls by this instance.
    /// During init, WKWebView is used to get the device's real User-Agent.
    /// The `MDApi.defaultUserAgent` string is then appended to that User-Agent
    private(set) var userAgent = MDApi.defaultUserAgent

    /// Boolean indicating whether a User-Agent has been set, meaning that
    /// the call to `buildUserAgent` shouldn't override it
    private var hasUserAgent = false

    /// The current session used for requests
    private(set) var session: URLSession = .shared

    /// The cookies valid for this session
    private(set) var cookieJar: HTTPCookieStorage = .shared

    override init() {
        super.init()
        self.buildUserAgent(suffix: MDApi.defaultUserAgent)

        // Session configuration directly reflects on cookieJar
        session.configuration.httpShouldSetCookies = true
        session.configuration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
        session.configuration.httpCookieStorage?.cookieAcceptPolicy = .onlyFromMainDocumentDomain
    }

    /// Append the given suffix to the phone's default User-Agent
    /// - Parameter suffix: The string to append after the default User-Agent
    private func buildUserAgent(suffix: String) {
        WKWebView().evaluateJavaScript("navigator.userAgent") { (result, _) in
            // Don't override a custom User Agent
            guard !self.hasUserAgent else {
                return
            }

            // Build a pretty User-Agent
            if let userAgent = result as? String {
                self.setUserAgent("\(userAgent) (using \(suffix))")
            } else {
                self.setUserAgent(suffix)
            }
        }
    }

    /// Change the User-Agent used for every API call
    /// - Parameter userAgent: The new user agent to use
    func setUserAgent(_ userAgent: String) {
        UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
        self.userAgent = userAgent
        self.hasUserAgent = true
    }

    /// Reset the session (clear cookies, credentials, caches...)
    ///
    /// Custom set cookies have to be reset as they will be deleted
    func resetSession() {
        cookieJar.removeCookies(since: .distantPast)
        session.flush {
        }
    }

    /// Set a cookie's value for the following requests
    /// - Parameter type: The type of cookie to set
    /// - Parameter value: The value of the cookie to set
    /// - Parameter sessionOnly: Whether the cookie should be deleted at the end of the session
    /// - Parameter secure: Whether the cookie should only be sent over secure connections
    func setCookie(type: CookieType, value: String, sessionOnly: Bool = true, secure: Bool = false) {
        let cookie = HTTPCookie(properties: [
            .path: MDRequestHandler.cookiePath,
            .domain: MDRequestHandler.cookieDomain,
            .name: type.rawValue,
            .value: value,
            .discard: sessionOnly,
            .secure: secure
        ])
        self.cookieJar.setCookie(cookie!)
    }

    /// Get the value of the cookie with the given type, if set
    /// - Parameter type: The type of cookie to read
    /// - Returns: The value of the cookie, if any
    func getCookie(type: CookieType) -> String? {
        guard let cookies = self.cookieJar.cookies else {
            return nil
        }
        return cookies.first(where: { (cookie) -> Bool in
            return cookie.name == type.rawValue
            })?.value
    }

    /// Perform an async get request
    /// - Parameter url: The URL to fetch
    /// - Parameter completion: The callback at the end of the request
    func get(url: URL, completion: @escaping RequestCompletion) {
        // Create a request with the correct user agent
        let request = NSMutableURLRequest(url: url)
        self.perform(request: request, completion: completion)
    }

    /// Perform an async post request
    /// - Parameter url: The URL to load
    /// - Parameter content: The dictionary representation of the request's body
    /// - Parameter completion: The callback at the end of the request
    ///
    /// Because of the way DDoS-Guard works, this request cannot be the first one to ever be done: the
    /// `.ddosGuard` cookie must be set
    func post(url: URL,
              content: [String: LosslessStringConvertible],
              encoding: BodyEncoding = .multipart,
              completion: @escaping RequestCompletion) {
        // Create the empty request
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        // Fill-in its body and headers based on the content and encoding
        switch encoding {
        case .multipart:
            createMultipartBody(from: content, for: request)
        case .urlencoded:
            createUrlEncodedBody(from: content, for: request)
        }

        // Make sure we don't trigger the DDoS-Guard
        self.handleDdosGuard(for: request) {
            self.perform(request: request, completion: completion)
        }
    }

    /// Perform thee given async request
    /// - Parameter request: The request to perform
    /// - Parameter completion: The callback at the end of the request
    func perform(request: NSMutableURLRequest, completion: @escaping RequestCompletion) {
        // Make sure the user agent is set
        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

        // TODO: Check Reachability.isConnectedToNetwork()

        // Cookies are automatically handled by the session, so just create the task
        let task = session.dataTask(with: request as URLRequest) { (data, _, error) in
            // TODO: Check response status code
            // print(response as? HTTPURLResponse)
            var output: String?
            if data != nil {
                output = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            }
            completion(output, error)
        }
        task.resume()
    }

}

extension MDRequestHandler {

    /// Build a random string of the given length using only numbers
    /// - Parameter length: The length of the string to return
    /// - Returns: The random string of numbers
    private func randomId(length: Int) -> String {
        let allowed = "0123456789"
        return String((0..<length).map { _ in allowed.randomElement()! })
    }

    /// Mimic the behavior if the JavaScript `FormData` object
    /// - Parameter content: The data to encode
    /// - Parameter request: The request to which to add the content
    ///
    /// The request is directly modified by adding the body and required headers
    private func createMultipartBody(from content: [String: LosslessStringConvertible],
                                     for request: NSMutableURLRequest) {
        let boundary = "---------------------------\(randomId(length: 30))"
        var body = ""
        for (key, value) in content {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            body += "\(value)\r\n"
        }
        body += "--\(boundary)--\r\n"
        request.httpBody = body.data(using: .utf8)!

        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
    }

    /// Mimic the behavior if the JavaScript `FormData` object
    /// - Parameter content: The data to encode
    /// - Parameter request: The request to which to add the content
    ///
    /// The request is directly modified by adding the body and required headers
    func createUrlEncodedBody(from content: [String: LosslessStringConvertible],
                              for request: NSMutableURLRequest) {
        var components = URLComponents(string: "")!
        components.queryItems = []
        for (key, value) in content {
            components.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)!
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }

    /// Handle requests so they don't go against DDoS-Guard's rules
    ///
    /// The `.ddosGuard` cookie must have been set during a previous request (either during this
    /// session or in the past)
    private func handleDdosGuard(for request: NSMutableURLRequest, completion: @escaping () -> Void) {
        guard let cookie = self.getCookie(type: .ddosGuard) else {
            // TODO: Fill-in error
            completion()
            return
        }

        // Set the origin and ddosGuard cookie values for this request
        request.setValue(MDApi.baseURL, forHTTPHeaderField: "Origin")
        request.setValue("\(CookieType.ddosGuard.rawValue)=\(cookie)", forHTTPHeaderField: "Cookie")

        // Wait for a bit to prevent the user from performing requests too often
        // TODO: ALso have a queue that limits the number of requests at the same time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }

    }

}
