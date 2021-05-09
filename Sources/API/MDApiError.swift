//
//  MDError.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Errors raised by the MangaDex API
@objc
public class MDApiError: NSObject, Error {

    /// Types of errors raised by MangaDexLib
    public enum ErrorType {

        /// The request completed with an unexpected status code
        case wrongStatusCode

        /// No DDoS-Guard cookie was found in the cookie jar
        ///
        /// A DDoS-Guard cookie has to be set before doing any `POST` request. The cookie is automatically set when
        /// performing a `GET` request, and is kept in between sessions
        case noDdosGuardCookie

        /// MangaDex decided that the user needs to solve a captcha before accessing the endpoint
        case captchaRequired

        /// The requests was started before the `MDRequestHandler` entered
        /// a ready state
        ///
        /// - Note: Thanks to the task queue, this should never occure
        case notReady

        /// The user needs to be authenticated to perform this request
        case loginRequired

        /// MangaDexLib failed to parse the response returned by the MangaDex API
        case decodingError

        /// MangaDexLib failed to encode the content of the request
        case encodingError

        /// This method is not implemented
        case notImplemented

        /// The performed action failed with an unknown error
        case actionFailed
    }

    /// Type of error represented by this object
    public let errorType: ErrorType

    /// Errors returned by the MangaDex API
    public let apiErrors: [MDError]

    /// Underlying errors raised by Swift methods
    public let underlyingError: Error?

    /// The raw content returned by the MangaDex API which triggered this error
    public let rawBody: String?

    /// Convenience `init` method
    /// - Parameter type: The type of error raised
    /// - Parameter body: The body of the error returned by the MangaDex API
    /// - Parameter error: The underlying error raised by Swift
    init(type: ErrorType, body: String? = nil, error: Error? = nil) {
        errorType = type
        underlyingError = error
        rawBody = body

        do {
            let result = try MDParser.parse(json: body ?? "", type: MDResult<String>.self)
            apiErrors = result.errors ?? []
        } catch {
            apiErrors = []
        }
    }

}
