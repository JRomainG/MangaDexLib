//
//  MDParser+Login.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The id of the login form in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<form method="post" id="login_form" action="[...]">`
    static private let loginFormId = "login_form"

    /// The id of the username input field  in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<input name="login_username" id="login_username">`
    static private let loginUsernameInputId = "login_username"

    /// The id of the username input field  in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<input name="login_password" id="login_password">`
    static private let loginPasswordInputId = "login_password"

    /// Find out if the given user was redirected to the login page
    /// - Parameter doc: The document the analyze
    /// - Returns: A boolean indicating whether this is the login page
    func isLoginPage(document: Document) -> Bool {
        do {
            let loginForm = try document.getElementById(MDParser.loginFormId)
            guard try loginForm?.getElementById(MDParser.loginUsernameInputId) != nil else {
                return false
            }
            guard try loginForm?.getElementById(MDParser.loginPasswordInputId) != nil else {
                return false
            }
        } catch {
            return false
        }

        return true
    }

}
