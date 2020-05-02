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
    /// `info.username` and `info.password` must be filled in, as well as
    /// `info.twoFactorCode` for two factor authentication
    private func performAuth(with info: MDAuth, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction(javascriptEnabled: false)
        let username = info.username ?? ""
        let password = info.password ?? ""
        let code = info.twoFactorCode ?? ""
        let body: [String: LosslessStringConvertible] = [
            MDRequestHandler.AuthField.username.rawValue: username,
            MDRequestHandler.AuthField.password.rawValue: password,
            MDRequestHandler.AuthField.twoFactor.rawValue: code,
            MDRequestHandler.AuthField.remember.rawValue: info.remember ? "1" : "0"
        ]

        // Make sure a two factor code is provided if necessary
        guard info.type == .regular || info.twoFactorCode != nil else {
            let response = MDResponse(type: .login, url: url, rawValue: "", error: nil)
            response.error = MDError.missingTwoFactor
            completion(response)
            return
        }

        let options = MDRequestOptions(encoding: .urlencoded, referer: MDPath.login().absoluteString)
        performPost(url: url, body: body, options: options, type: .login, onError: completion) { (response) in
            // When authentication is successful, the cookie is set. If it's not, there was an error
            if let token = self.requestHandler.getCookie(type: .authToken) {
                response.token = token
            } else {
                response.error = MDError.wrongAuthInfo
            }
            completion(response)
        }
    }

    /// Set the token in the `MDRequestHandler` cookies so the user is authenticated for
    /// the next requests
    private func setAuthToken(_ token: String?, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction()
        let response = MDResponse(type: .login, url: url, rawValue: "", error: nil)

        guard let authToken = token else {
            response.error = MDError.genericAuthFailure
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
        case .regular, .twoFactor:
            performAuth(with: info, completion: completion)
        case .token:
            setAuthToken(info.token, completion: completion)
        }
    }

    /// Attempt to login with the given credentials
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    public func logout(completion: @escaping MDCompletion) {
        let url = MDPath.logoutAction()
        performPost(url: url, body: [:], type: .logout, onError: completion) { (response) in
            self.requestHandler.deleteCookie(type: .authToken)
            self.requestHandler.deleteCookie(type: .sessionId)
            completion(response)
        }
    }

    /// Checks whether the user has an auth token set
    ///
    /// This does not check whether the token is valid or not
    public func isLoggedIn() -> Bool {
        return requestHandler.getCookie(type: .authToken) != nil
    }

}
