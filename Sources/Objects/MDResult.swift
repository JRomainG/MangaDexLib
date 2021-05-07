//
//  MDResult.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a result returned by the MangaDex API
public struct MDResult: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// The data contained in this response, formated in JSON
    ///
    /// This will be `nil` if the status is not `ok`
    public let jsonData: String?

    /// The relationships contained in this response
    ///
    /// This will be `nil` if the status is not `ok`
    public let relationships: [MDObject]?

    /// The errors contained in this response
    ///
    /// This will be `nil` if the status is `ok`
    public let errors: [MDError]?

}

extension MDResult {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case jsonData = "data"
        case relationships
        case errors
    }

}
