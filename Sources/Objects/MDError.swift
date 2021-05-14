//
//  MDError.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an error returned by the MangaDex API
public struct MDError: Decodable {

    /// The error's ID
    public let errorId: String

    /// The error's status code (e.g. 404)
    public let status: Int

    /// The error's title (e.g. `not_found_http_exception`)
    public let title: String

    /// The error's user-friendly detailed description
    public let detail: String?

    /// The error's context
    ///
    /// According to the official documentation:
    /// > Once an endpoint decides that a captcha needs to be solved, a 403 Forbidden response will be returned [...]
    /// > The sitekey needed for recaptcha to function is provided [...] in the error context, specified as `siteKey`
    /// > parameter.
    public let context: [String: String]?

}

extension MDError {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case errorId = "id"
        case status
        case title
        case detail
        case context
    }

}
