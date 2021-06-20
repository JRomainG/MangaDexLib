//
//  MDApi+Account.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Create a new account with the given information
    /// - Parameter info: The account information
    /// - Parameter completion: The completion block called once the request is done
    public func createAccount(info: MDAccountInfo, completion: @escaping (MDResult<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.createAccount()
        performBasicPostCompletion(url: url, data: info, completion: completion)
    }

    /// Activate an account
    /// - Parameter activationCode: The activation code sent to the provided email address
    /// - Parameter completion: The completion block called once the request is done
    public func activateAccount(activationCode: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.activateAccount(activationCode: activationCode)
        performGet(url: url) { (response) in
            completion(response.error)
        }
    }

    /// Ask for an activation code to be resent
    /// - Parameter email: The account email
    /// - Parameter completion: The completion block called once the request is done
    public func resendActivationCode(email: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.resendActivationCode()
        let data = [
            "email": email
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

    /// Start the recovery process for an account
    /// - Parameter email: The account email
    /// - Parameter completion: The completion block called once the request is done
    public func requestAccountRecovery(email: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.requestAccountRecovery()
        let data = [
            "email": email
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

    /// Commplete the recovery process for an account
    /// - Parameter recoveryCode: The recovery code sent to the account's email address
    /// - Parameter newPassword: The new password to set for the account
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: Having called `requestAccountRecovery`
    public func completeAccountRecovery(recoveryCode: String,
                                        newPassword: String,
                                        completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.completeAccountRecovery(recoveryCode: recoveryCode)
        let data = [
            "newPassword": newPassword
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

}
