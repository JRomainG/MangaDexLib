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
    public static let baseURL = "https://api.mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    public static let defaultUserAgent = "MangaDexLib"

    /// Instance of `MDRequestHandler` used to perform all requests
    public let requestHandler = MDRequestHandler()

    /// TypeAlias for completion blocks
    public typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the User-Agent to use for requests
    public func setUserAgent(_ userAgent: String) {
        requestHandler.setUserAgent(userAgent)
    }

}

// MARK: - MDApi Generic Helper Methods

extension MDApi {

    /// Wrapper around MDRequestHandler's get method
    /// - Parameter url: The URL to fetch
    /// - Parameter options: The options to use for this request
    /// - Parameter onError: The user-provided completion that will be called in case of an error
    /// - Parameter onSuccess: The internal completion called if the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    func performGet(url: URL,
                    options: MDRequestOptions? = nil,
                    onError: @escaping MDCompletion,
                    onSuccess: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, onError: onError, onSuccess: onSuccess)
        requestHandler.get(url: url, options: options, completion: completion)
    }

    /// Wrapper around MDRequestHandler's post method
    /// - Parameter url: The URL to load
    /// - Parameter body: The content of the request
    /// - Parameter options: The options to use for this request
    /// - Parameter onError: The user-provided completion that will be called in case of an error
    /// - Parameter onSuccess: The internal completion called if the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    func performPost(url: URL,
                     body: [String: LosslessStringConvertible],
                     options: MDRequestOptions? = nil,
                     onError: @escaping MDCompletion,
                     onSuccess: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, onError: onError, onSuccess: onSuccess)
        requestHandler.post(url: url, content: body, options: options, completion: completion)
    }

    /// Constructor for a generic completion block
    /// - Parameter url: The URL to load
    /// - Parameter onError: The completion called in case of an error
    /// - Parameter onSuccess: The completion called if the requests succeeds
    private func requestCompletionBlock(url: URL,
                                        onError: @escaping MDCompletion,
                                        onSuccess: @escaping MDCompletion) -> MDRequestHandler.RequestCompletion {
        return { (httpResponse, content, error) in
            // Build a response object for the completion
            let response = MDResponse(url: url,
                                      error: error,
                                      content: content,
                                      status: httpResponse?.statusCode)
            // Propagate errors from the request manager
            guard error == nil, content != nil else {
                onError(response)
                return
            }

            // Make sure the status code is correct
            guard let statusCode = httpResponse?.statusCode, 200...399 ~= statusCode else {
                response.error = MDApiError.wrongStatusCode
                onError(response)
                return
            }

            response.error == nil ? onSuccess(response) : onError(response)
        }
    }

}
