//
//  MDApi+Auth.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

// MARK: - MDApi Auth

extension MDApi {

    /// Perform a POST request with the given credentials to login
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    ///
    /// `info.username` and `info.password` must not be filled in
    private func performAuth(with info: MDAuth, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction(javascriptEnabled: false)
        let username = info.username ?? ""
        let password = info.password ?? ""
        let body: [String: LosslessStringConvertible] = [
            MDRequestHandler.AuthField.username.rawValue: username,
            MDRequestHandler.AuthField.password.rawValue: password,
            MDRequestHandler.AuthField.twoFactor.rawValue: "",
            MDRequestHandler.AuthField.remember.rawValue: info.remember ? "1" : "0"
        ]
        performPost(url: url,
                    body: body,
                    encoding: .urlencoded,
                    type: .login,
                    errorCompletion: completion) { (response) in
                        // Save the cookie in the response so it's accessible from outside the API
                        response.token = self.requestHandler.getCookie(type: .authToken)
                        completion(response)
        }
    }

    /// Set the token in the `MDRequestHandler` cookies so the user is authenticated for
    /// the next requests
    private func setAuthToken(_ token: String?, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction()
        let response = MDResponse(type: .login, url: url, rawValue: "", error: nil)

        guard let authToken = token else {
            response.error = MDError.authFailure
            completion(response)
            return
        }
        requestHandler.setCookie(type: .authToken, value: authToken, sessionOnly: false, secure: true)
        response.token = authToken
        completion(response)
    }

    /// Attempt to login with the given credentials
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    public func login(with info: MDAuth, completion: @escaping MDCompletion) {
        guard !isLoggedIn() else {
            let request = MDResponse(type: .login, error: MDError.alreadyLoggedIn)
            completion(request)
            return
        }

        switch info.type {
        case .regular:
            performAuth(with: info, completion: completion)
        case .token:
            setAuthToken(info.token, completion: completion)
        default:
            let request = MDResponse(type: .login, error: MDError.notImplemented)
            completion(request)
        }
    }

    /// Attempt to login with the given credentials
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    public func logout(completion: @escaping MDCompletion) {
        let url = MDPath.logoutAction()
        performPost(url: url, body: [:], type: .logout, errorCompletion: completion, success: completion)
    }

    /// Checks whether the user has an auth token set
    ///
    /// This does not check whether the token is valid or not
    public func isLoggedIn() -> Bool {
        return requestHandler.getCookie(type: .authToken) != nil
    }

}
