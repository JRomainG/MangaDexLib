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
        case rememberToken = "mangadex_rememberme_token"
        case sessionId = "mangadex_session"
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

    /// Perform an async get request
    /// - Parameter url: The URL to fetch
    /// - Parameter completion: The callback at the end of the request
    func get(url: URL, completion: @escaping RequestCompletion) {
        // Create a request with the correct user agent
        let request = NSMutableURLRequest(url: url)
        self.perform(request: request, completion: completion)
    }

    func post(url: URL, content: String, completion: @escaping RequestCompletion) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = content.data(using: .utf8)
        self.perform(request: request, completion: completion)
    }

    func perform(request: NSMutableURLRequest, completion: @escaping RequestCompletion) {
        // Make sure the user agent is set
        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

        // Cookies are automatically handled by the session, so just create the task
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // TODO: Check response status code
            var output: String?
            if data != nil {
                output = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            }
            completion(output, error)
        }
        task.resume()
    }

}
