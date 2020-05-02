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
    public var server: MDServer = .automatic

    /// Whether to show rated mangas of not
    public var ratedFilter: MDRatedFilter = .noR18 {
        didSet {
            // Update the stored cookie to reflect the change
            requestHandler.setCookie(type: .ratedFilter, value: String(ratedFilter.rawValue))
        }
    }

    /// Instance of `MDRequestHandler` used to perform all requests
    public let requestHandler = MDRequestHandler()

    /// Instance of `MDParser` used to parse the results of the requests
    let parser = MDParser()

    /// TypeAlias for completion blocks
    public typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the User-Agent to use for requests
    public func setUserAgent(_ userAgent: String) {
        requestHandler.setUserAgent(userAgent)
    }

}

// MARK: - MDApi Generic Helper Methods

extension MDApi {

    /// Ensure the user is logged in
    /// - Parameter onError: The user-provided completion that will be called in case of an error
    /// - Parameter onSuccess: The internal completion called if the requests succeeds
    func checkLoggedIn(url: URL, onError: @escaping MDCompletion, onSuccess: () -> Void) {
        guard isLoggedIn() else {
            let response = MDResponse(type: .generic, url: url, error: MDError.loginRequired)
            onError(response)
            return
        }
        onSuccess()
    }

    /// Wrapper around MDRequestHandler's get method
    /// - Parameter url: The URL to fetch
    /// - Parameter type: The type of response that is expected
    /// - Parameter onError: The user-provided completion that will be called in case of an error
    /// - Parameter onSuccess: The internal completion called if the requests succeeds
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
    /// - Parameter onError: The user-provided completion that will be called in case of an error
    /// - Parameter onSuccess: The internal completion called if the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    func performPost(url: URL,
                     body: [String: LosslessStringConvertible],
                     options: MDRequestOptions? = nil,
                     type: MDResponse.ResponseType,
                     onError: @escaping MDCompletion,
                     onSuccess: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, type: type, onError: onError, onSuccess: onSuccess)
        requestHandler.post(url: url, content: body, options: options, completion: completion)
    }

    /// Constructor for a generic completion block
    /// - Parameter url: The URL to load
    /// - Parameter type: The type of response that is expected
    /// - Parameter onError: The completion called in case of an error
    /// - Parameter onSuccess: The completion called if the requests succeeds
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
            // Propagate errors from the request manager
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

            // Check if an error message was returned by the website
            if let msg = MDPath.getQueryItem(for: MDPath.AjaxParam.errorMessage.rawValue, in: httpResponse?.url) {
                switch MDPath.AjaxError(rawValue: msg) {
                case .missingTwoFactor:
                    response.error = MDError.missingTwoFactor
                case .wrongAuthInfo, .wrongTwoFactorCode:
                    response.error = MDError.wrongAuthInfo
                default:
                    break
                }
            }
            response.error == nil ? onSuccess(response) : onError(response)
        }
    }

}