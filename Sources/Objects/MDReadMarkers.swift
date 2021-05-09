//
//  MDReadMarkers.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 09/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a result with a list of chapters read by the logged-in user
public struct MDReadMarkers: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// The list of read chapter uuids
    /// - Note: This will be `nil` if the status is not `ok`
    public let chapters: [String]?

    /// The errors contained in this response
    /// - Note: This will be `nil` if the status is `ok`
    public let errors: [MDError]?

}

extension MDReadMarkers {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case chapters = "data"
        case errors
    }

}
