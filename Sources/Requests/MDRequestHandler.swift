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
public class MDRequestHandler: NSObject {

    /// The different types of cookies that can be changed by the API
    public enum CookieType: String {
        /// The cookie used to store the auth token
        /// - Note: The cookie is valid for 1 year
        case authToken = "mangadex_rememberme_token"

        /// A cookie used by DDoS-Guard
        case ddosGuard1 = "__ddg1"

        /// A cookie used by DDoS-Guard
        case ddosGuard2 = "__ddg2"

        /// A cookie used by DDoS-Guard
        case ddosGuardId = "__ddgid"

        /// A cookie used by DDoS-Guard
        case ddosGuardMark = "__ddgmark"
    }

    /// An alias for the completion blocks called after requests
    ///
    /// Parameters are the underlying response, its string content and its error (if relevant)
    public typealias RequestCompletion = (HTTPURLResponse?, String?, MDApiError?) -> Void

    /// Domain used by the MangaDex API to set cookies
    static let cookieDomain: String = ".api.mangadex.org"

    /// Path used by MangaDex to set cookies
    static let cookiePath: String = "/"

    /// User-Agent used for calls by this instance
    ///
    /// During init, WKWebView is used to get the device's real User-Agent. The `MDApi.defaultUserAgent` string is then
    /// appended to that User-Agent
    public private(set) var userAgent = MDApi.defaultUserAgent

    /// Boolean indicating whether a User-Agent has been set, meaning that the call to `buildUserAgent` shouldn't
    /// override it
    private var hasUserAgent = false

    /// The current session used for requests
    public private(set) var session: URLSession = .shared

    /// The cookies valid for this session
    public private(set) var cookieJar: HTTPCookieStorage = .shared

    /// Authentication token provided by the MangaDex API after login
    /// - Note: This token is synchronised with `MDApi.sessionJwt`
    internal var authToken: String?

    /// The delay (in seconds) added before doing a requests which goes through the `handleDdosGuard` method
    ///
    /// This delay is only added for `POST`, `PUT`, or `DELETE` requests, so it will be mostly invisible to the user
    /// during normal use
    public private(set) var ddosGuardDelay: Double = 0.1

    /// Boolean indicating whether the handler is ready to start performing requests
    ///
    /// The handler is considered `unready` before its User-Agent has been set, because some requests (mainly those
    /// requiring login) fail if a proper User-Agent isn't sent
    public private(set) var isReady: Bool = false

    /// List of requests that haven't been started yet
    ///
    /// Requests are added to the queue before the handler is ready. Once ready, all the requests are automatically
    /// started
    public private(set) var requestQueue: [(NSMutableURLRequest, RequestCompletion)] = []

    override init() {
        super.init()
        buildUserAgent(suffix: MDApi.defaultUserAgent)

        // Session configuration directly reflects on cookieJar
        session.configuration.httpShouldSetCookies = true
        session.configuration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
        session.configuration.httpCookieStorage?.cookieAcceptPolicy = .onlyFromMainDocumentDomain
        session.configuration.httpMaximumConnectionsPerHost = 5
    }

    /// Append the given suffix to the phone's default User-Agent
    /// - Parameter suffix: The string to append after the default User-Agent
    private func buildUserAgent(suffix: String) {
        WKWebView().evaluateJavaScript("navigator.userAgent") { (result, _) in
            // Don't override a custom User Agent
            guard !self.hasUserAgent else {
                self.didBecomeReady()
                return
            }

            // Build a pretty User-Agent
            if let userAgent = result as? String {
                self.setUserAgent("\(userAgent) (using \(suffix))")
            } else {
                self.setUserAgent(suffix)
            }

            self.didBecomeReady()
        }
    }

    /// Change the User-Agent used for every API call
    /// - Parameter userAgent: The new user agent to use
    public func setUserAgent(_ userAgent: String) {
        UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
        self.userAgent = userAgent
        self.hasUserAgent = true
    }

    /// Change the delay added before performing a `POST`, `PUT`, or `DELETE` request (in seconds)
    /// - Parameter delay: The delay (in seconds) added before each request
    /// - Note: The minimum value is capped at 0.05 seconds. Default is 0.1
    public func setDdosGuardDelay(_ delay: Double) {
        ddosGuardDelay = max(delay, 0.05)
    }

    /// Change the maximum number of concurrent connections that will be made
    /// by the handler
    /// - Parameter maxConnections: The maximum number of concurrent connections
    /// - Note: The maximum value is capped at 25, and the minimum at 1. Default is 5
    public func setMaxConcurrentConnections(_ maxConnections: Int) {
        let connections = max(1, min(maxConnections, 25))
        session.configuration.httpMaximumConnectionsPerHost = connections
    }

    /// Reset the session (clear cookies, credentials, caches...)
    /// - Note: Custom set cookies have to be reset as they will be deleted
    public func resetSession() {
        cookieJar.removeCookies(since: .distantPast)
        session.flush {
        }
    }

    /// Called when the handler finishes its initialization
    private func didBecomeReady() {
        // Perform on main thread to avoid concurrency issues
        DispatchQueue.main.async {
            self.isReady = true

            // Start all pending tasks
            for (request, completion) in self.requestQueue {
                self.startTask(for: request, completion: completion)
            }
        }
    }

    /// Set a cookie's value for the following requests
    /// - Parameter type: The type of cookie to set
    /// - Parameter value: The value of the cookie to set
    /// - Parameter sessionOnly: Whether the cookie should be deleted at the end of the session
    /// - Parameter secure: Whether the cookie should only be sent over secure connections
    public func setCookie(type: CookieType, value: String, sessionOnly: Bool = true, secure: Bool = false) {
        let cookie = HTTPCookie(properties: [
            .path: MDRequestHandler.cookiePath,
            .domain: MDRequestHandler.cookieDomain,
            .name: type.rawValue,
            .value: value,
            .discard: sessionOnly,
            .secure: secure
        ])
        cookieJar.setCookie(cookie!)
    }

    /// Get the value of the cookie with the given type, if set
    /// - Parameter type: The type of cookie to read
    /// - Returns: The value of the cookie, if any
    public func getCookie(type: CookieType) -> String? {
        guard let cookies = cookieJar.cookies else {
            return nil
        }
        return cookies.first(where: { (cookie) -> Bool in
            return cookie.name == type.rawValue
            })?.value
    }

    /// Delete the the cookie with the given type, if set
    /// - Parameter type: The type of cookie to delete
    public func deleteCookie(type: CookieType) {
        let cookie = cookieJar.cookies?.first(where: { (cookie) -> Bool in
            return cookie.name == type.rawValue
            })
        if cookie != nil {
            cookieJar.deleteCookie(cookie!)
        }
    }

    /// Perform an async get request
    /// - Parameter url: The URL to fetch
    /// - Parameter completion: The callback at the end of the request
    public func get(url: URL, completion: @escaping RequestCompletion) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        perform(request: request, completion: completion)
    }

    /// Perform an async post request
    /// - Parameter url: The URL to load
    /// - Parameter content: The object to JSON-encode in the request's body
    /// - Parameter completion: The callback at the end of the request
    ///
    /// Because of the way DDoS-Guard works, this request cannot be the first one to ever be done. It is best to always
    /// start with a `ping` request to make sure the `ddosGuard1` cookie is set.
    /// - Precondition: The `.ddosGuard` cookie must be set
    public func post<T: Encodable>(url: URL, content: T, completion: @escaping RequestCompletion) {
        // Create the empty request
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        // Fill-in its body and headers based on the content and options
        do {
            request.httpBody = try JSONEncoder().encode(content)
        } catch {
            completion(nil, nil, MDApiError(type: .encodingError, body: nil, error: error))
        }

        // Make sure we don't trigger DDoS-Guard
        handleDdosGuard(for: request) { error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            self.perform(request: request, completion: completion)
        }
    }

    /// Perform an async put request
    /// - Parameter url: The URL to load
    /// - Parameter content: The object to JSON-encode in the request's body
    /// - Parameter completion: The callback at the end of the request
    /// - Precondition: The `.ddosGuard` cookie must be set
    public func put<T: Encodable>(url: URL, content: T, completion: @escaping RequestCompletion) {
        // Create the empty request
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"

        // Fill-in its body and headers based on the content and options
        do {
            request.httpBody = try JSONEncoder().encode(content)
        } catch {
            completion(nil, nil, MDApiError(type: .encodingError, body: nil, error: error))
        }

        // Make sure we don't trigger DDoS-Guard
        handleDdosGuard(for: request) { error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            self.perform(request: request, completion: completion)
        }
    }

    /// Perform an async put request
    /// - Parameter url: The URL to load
    /// - Parameter content: The object to JSON-encode in the request's body
    /// - Parameter completion: The callback at the end of the request
    /// - Precondition: The `.ddosGuard` cookie must be set
    public func delete(url: URL, completion: @escaping RequestCompletion) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"

        // Make sure we don't trigger DDoS-Guard
        handleDdosGuard(for: request) { error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            self.perform(request: request, completion: completion)
        }
    }

    /// Perform thee given async request
    /// - Parameter request: The request to perform
    /// - Parameter completion: The callback at the end of the request
    func perform(request: NSMutableURLRequest, completion: @escaping RequestCompletion) {
        // Wait until the handler is ready before starting requests
        DispatchQueue.main.async {
            if self.isReady {
                self.startTask(for: request, completion: completion)
            } else {
                self.requestQueue.append((request, completion))
            }
        }
    }

    /// Handle creating (and starting) a `URLSessionTask` for the given request
    ///
    /// - Attention: Should only be called if the handler is ready
    @objc
    private func startTask(for request: NSMutableURLRequest, completion: @escaping RequestCompletion) {
        // Make sure the handler is ready
        guard isReady else {
            completion(nil, nil, MDApiError(type: .notReady))
            return
        }

        // Make sure the headers are correct
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        // Authenticate using the saved token if there is one
        if let jwt = authToken {
            request.setValue("bearer \(jwt)", forHTTPHeaderField: "Authorization")
        }

        // Cookies are automatically handled by the session, so just create the task
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            var output: String?
            var apiError: MDApiError?
            if data != nil {
                output = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            }
            if error != nil {
                apiError = MDApiError(type: .actionFailed, body: output, error: error)
            }
            completion(response as? HTTPURLResponse, output, apiError)
        }
        task.resume()
    }

}

extension MDRequestHandler {

    /// Handle requests so they don't go against DDoS-Guard's rules
    /// - Parameter request: The request for which DDoS-Guard mitigations should be applied
    /// - Parameter completion: The callback once the request is ready
    ///
    /// - Precondition: The `.ddosGuard1` cookie must have been set during a previous request (either during this
    /// session or in the past)
    private func handleDdosGuard(for request: NSMutableURLRequest, completion: @escaping (MDApiError?) -> Void) {
        guard getCookie(type: .ddosGuard1) != nil else {
            completion(MDApiError(type: .noDdosGuardCookie))
            return
        }

        // Set the origin for the request, just in case
        request.setValue(MDApi.websiteBaseURL, forHTTPHeaderField: "Origin")

        // Wait for a bit to prevent the user from performing requests too quickly
        DispatchQueue.main.asyncAfter(deadline: .now() + ddosGuardDelay) {
            completion(nil)
        }
    }

}
