//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The main MangaDex API class, which should be used to access the framework's capabilities
class MDApi: NSObject {

    /// URL for the MangaDex website
    static let baseURL = "https://mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    static let defaultUserAgent = "MangaDexLib"

    /// The server from which to server manga pages
    private(set) var server: MDServer = .automatic

    /// Whether to show rated manga of not
    private(set) var ratedFilter: MDRatedFilter = .noR18

    /// Instance of `MDRequestHandler` used to perform all requests
    internal let requestHandler = MDRequestHandler()

    /// Instance of `MDParser` used to parse the results of the requests
    internal let parser = MDParser()

    /// TypeAlias for completion blocks
    typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the rated filter cookie
    func setRatedFilter(_ filter: MDRatedFilter) {
        self.ratedFilter = filter
        requestHandler.setCookie(type: .ratedFilter, value: String(filter.rawValue))
    }

    /// Setter for the server to use when fetching chapter pages
    func setServer(_ server: MDServer) {
        self.server = server
    }

    /// Setter for the User-Agent to use for requests
    func setUserAgent(_ userAgent: String) {
        requestHandler.setUserAgent(userAgent)
    }

}

// MARK: - MDApi Generic Helper Methods

extension MDApi {

    /// Wrapper around MDRequestHandler's get method
    /// - Parameter url: The URL to fetch
    /// - Parameter type: The type of response that is expected
    /// - Parameter errorCompletion: The user-provided completion that will be called in case of an error
    /// - Parameter success: The internal completion called in the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    internal func performGet(url: URL,
                             type: MDResponse.ResponseType,
                             errorCompletion: @escaping MDCompletion,
                             success: @escaping MDCompletion) {
        requestHandler.get(url: url) { (http, content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: type, url: url, error: error, content: content, status: http?.statusCode)
            guard error == nil, content != nil else {
                errorCompletion(response)
                return
            }

            // Make sure the status code is correct
            guard let statusCode = http?.statusCode, 200...399 ~= statusCode else {
                response.error = MDError.wrongStatusCode
                errorCompletion(response)
                return
            }
            success(response)
        }
    }

    /// Wrapper around MDRequestHandler's post method
    /// - Parameter url: The URL to load
    /// - Parameter body: The content of the request
    /// - Parameter type: The type of response that is expected
    /// - Parameter errorCompletion: The user-provided completion that will be called in case of an error
    /// - Parameter success: The internal completion called in the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    internal func performPost(url: URL,
                              body: [String: LosslessStringConvertible],
                              encoding: MDRequestHandler.BodyEncoding = .multipart,
                              type: MDResponse.ResponseType,
                              errorCompletion: @escaping MDCompletion,
                              success: @escaping MDCompletion) {
        requestHandler.post(url: url, content: body, encoding: encoding) { (http, content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: type, url: url, error: error, content: content, status: http?.statusCode)
            guard error == nil, content != nil else {
                errorCompletion(response)
                return
            }

            // Make sure the status code is correct
            guard let statusCode = http?.statusCode, 400...599 ~= statusCode else {
                response.error = MDError.wrongStatusCode
                errorCompletion(response)
                return
            }
            success(response)
        }
    }

}
