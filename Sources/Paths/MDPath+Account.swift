//
//  MDPath+Account.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to create a new account
    /// - Returns: The MangaDex URL
    public static func createAccount() -> URL {
        return buildUrl(for: .account, with: ["create"])
    }

    /// Build the URL to activate an account
    /// - Parameter activationCode: The activation code sent to the provided email address
    /// - Returns: The MangaDex URL
    public static func activateAccount(activationCode: String) -> URL {
        return buildUrl(for: .account, with: ["activate", activationCode])
    }

    /// Build the URL to resend an activation code
    /// - Returns: The MangaDex URL
    public static func resendActivationCode() -> URL {
        return buildUrl(for: .account, with: ["activate", "resend"])
    }

    /// Build the URL to start the recovery process for an account
    /// - Returns: The MangaDex URL
    public static func requestAccountRecovery() -> URL {
        return buildUrl(for: .account, with: ["recover"])
    }

    /// Build the URL to complete the recovery process for an account
    /// - Parameter recoveryCode: The activation code sent to the account email address
    /// - Returns: The MangaDex URL
    public static func completeAccountRecovery(recoveryCode: String) -> URL {
        return buildUrl(for: .account, with: ["recover", recoveryCode])
    }

}
