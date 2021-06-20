//
//  MDApi+Auth.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Login to MangaDex
    /// - Parameter credentials: The user's credentials
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must *not* be logged-in
    public func login(credentials: MDAuthCredentials, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.login()
        performPost(url: url, body: credentials) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(response.error)
                return
            }

            // Parse the response and save the JWT as they might be useful for future requests
            do {
                let result = try MDParser.parse(json: response.content, type: MDResult<String>.self)
                self.sessionJwt = result.token?.sessionJwt ?? self.sessionJwt
                self.refreshJwt = result.token?.refreshJwt ?? self.refreshJwt
                completion(nil)
            } catch {
                let error = MDApiError(type: .decodingError, url: url, body: response.content, error: error)
                completion(error)
            }
        }
    }

    /// Logout of MangaDex
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func logout(completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.logout()
        performPost(url: url, body: "") { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(response.error)
                return
            }
            // The tokens are no longer valid, so forget them
            self.sessionJwt = nil
            self.refreshJwt = nil
            completion(nil)
        }
    }

    /// Check that the current session token is valid and get its information
    /// - Parameter completion: The completion block called once the request is done
    public func checkToken(completion: @escaping (MDAuthInfo?, MDApiError?) -> Void) {
        let url = MDPath.checkToken()
        performGet(url: url) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }

            do {
                let result = try MDParser.parse(json: response.content, type: MDAuthInfo.self)
                completion(result, nil)
            } catch {
                let error = MDApiError(type: .decodingError, url: url, body: response.content, error: error)
                completion(nil, error)
            }
        }
    }

    /// Refresh the current session token
    /// - Parameter completion: The completion block called once the request is done
    ///
    /// This should be called every 15 minutes, as the session JWT will have expired
    /// - Precondition: The user must be logged-in
    public func refreshToken(completion: @escaping (MDApiError?) -> Void) {
        // Ensure we have a refresh token
        guard let refreshToken = self.refreshJwt else {
            completion(MDApiError(type: .loginRequired))
            return
        }

        let url = MDPath.refreshToken()
        let data = [
            "token": refreshToken
        ]
        performPost(url: url, body: data) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(response.error)
                return
            }

            // Parse the response and save the JWT as they might be useful for future requests
            do {
                let result = try MDParser.parse(json: response.content, type: MDResult<String>.self)
                self.sessionJwt = result.token?.sessionJwt ?? self.sessionJwt
                self.refreshJwt = result.token?.refreshJwt ?? self.refreshJwt
                completion(nil)
            } catch {
                let error = MDApiError(type: .decodingError, url: url, body: response.content, error: error)
                completion(error)
            }
        }
    }

}
