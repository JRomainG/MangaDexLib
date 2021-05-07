//
//  MDError.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Custom errors raised by the various components of the API
public enum MDApiError: Error {

    /// The request completed with an unexpected status code
    case wrongStatusCode

    /// No DDoS-Guard cookie was found in the cookie jar
    ///
    /// A DDoS-Guard cookie has to be set before doing any `POST`
    /// request. The cookie is automatically set when performing a
    /// `GET` request, and is kept in between sessions
    case noDdosGuardCookie

    /// The requests was started before the `MDRequestHandler` entered
    /// a ready state
    ///
    /// Thanks to the task queue, this should never occure
    case notReady

    /// The user needs to be authenticated to perform this request
    case loginRequired

    /// The user is already logged in, they can't attempt to log in again
    case alreadyLoggedIn

    /// The authentication attempt failed with an unknown error
    case genericAuthFailure

    /// The authentication attempt failed because either the username,
    /// password or two factor code was wrong
    case wrongAuthInfo

    /// The authentication attempt failed because a two factor authentication code
    /// was missing
    case missingTwoFactor

    /// This method is not implemented
    case notImplemented

    /// The performed action failed with an unknown error
    case actionFailed

}
