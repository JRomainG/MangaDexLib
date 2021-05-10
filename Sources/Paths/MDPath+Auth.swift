//
//  MDPath+Auth.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to login
    /// - Returns: The MangaDex URL
    static func login() -> URL {
        return buildUrl(for: .auth, with: ["login"])
    }

    /// Build the URL to logout
    /// - Returns: The MangaDex URL
    static func logout() -> URL {
        return buildUrl(for: .auth, with: ["logout"])
    }

    /// Build the URL to check the validity of the current auth token and get its associated roles and permissions
    /// - Returns: The MangaDex URL
    static func checkToken() -> URL {
        return buildUrl(for: .auth, with: ["check"])
    }

    /// Build the URL to refresh the auth token
    /// - Returns: The MangaDex URL
    static func refreshToken() -> URL {
        return buildUrl(for: .auth, with: ["refresh"])
    }

}
