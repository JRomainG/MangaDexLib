//
//  MDError.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

enum MDError: Error {
    // Request errors
    case wrongStatusCode
    case noDdosGuardCookie

    // Auth errors
    case loginRequired
    case alreadyLoggedIn
    case authFailure
    case notImplemented
}
