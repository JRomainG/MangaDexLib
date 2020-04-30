//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The main MangaDex API class, which should be used to access the framework's capabilities
public class MDApi: NSObject {

    /// URL for the MangaDex website
    public static let baseURL = "https://mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    public static let defaultUserAgent = "MangaDexLib"

    /// The server from which to server manga pages
    public private(set) var server: MDServer = .automatic

    /// Whether to show rated manga of not
    public private(set) var ratedFilter: MDRatedFilter = .noR18

    /// Instance of `MDRequestHandler` used to perform all requests
    public let requestHandler = MDRequestHandler()

    /// Instance of `MDParser` used to parse the results of the requests
    let parser = MDParser()

    /// TypeAlias for completion blocks
    public typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the rated filter cookie
    public func setRatedFilter(_ filter: MDRatedFilter) {
        self.ratedFilter = filter
        requestHandler.setCookie(type: .ratedFilter, value: String(filter.rawValue))
    }

    /// Setter for the server to use when fetching chapter pages
    public func setServer(_ server: MDServer) {
        self.server = server
    }

    /// Setter for the User-Agent to use for requests
    public func setUserAgent(_ userAgent: String) {
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
    func performGet(url: URL,
                    type: MDResponse.ResponseType,
                    onError: @escaping MDCompletion,
                    onSuccess: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, type: type, onError: onError, onSuccess: onSuccess)
        requestHandler.get(url: url, completion: completion)
    }

    /// Wrapper around MDRequestHandler's post method
    /// - Parameter url: The URL to load
    /// - Parameter body: The content of the request
    /// - Parameter type: The type of response that is expected
    /// - Parameter errorCompletion: The user-provided completion that will be called in case of an error
    /// - Parameter success: The internal completion called in the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    func performPost(url: URL,
                     body: [String: LosslessStringConvertible],
                     encoding: MDRequestHandler.BodyEncoding = .multipart,
                     type: MDResponse.ResponseType,
                     onError: @escaping MDCompletion,
                     onSuccess: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, type: type, onError: onError, onSuccess: onSuccess)
        requestHandler.post(url: url, content: body, encoding: encoding, completion: completion)
    }

    private func requestCompletionBlock(url: URL,
                                        type: MDResponse.ResponseType,
                                        onError: @escaping MDCompletion,
                                        onSuccess: @escaping MDCompletion) -> MDRequestHandler.RequestCompletion {
        return { (httpResponse, content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: type,
                                      url: url,
                                      error: error,
                                      content: content,
                                      status: httpResponse?.statusCode)

            guard error == nil, content != nil else {
                onError(response)
                return
            }

            // Make sure the status code is correct
            guard let statusCode = httpResponse?.statusCode, 200...399 ~= statusCode else {
                response.error = MDError.wrongStatusCode
                onError(response)
                return
            }
            onSuccess(response)
        }
    }

}
