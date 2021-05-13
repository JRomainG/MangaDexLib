//
//  MDReadingStatuses.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 09/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a result with a list of manga reading statuses for the logged-in user
public struct MDReadingStatuses: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// A dictionary mapping manga UUIDs to their reading status
    /// - Note: This will be `nil` if the status is not `ok`
    /// TODO: The API documentation does not seem to match the implementation, so a list is returned here instead
    public let statuses: [String: MDReadingStatus?]?

    /// The errors contained in this response
    /// - Note: This will be `nil` if the status is `ok`
    public let errors: [MDError]?

}

extension MDReadingStatuses {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case statuses
        case errors
    }

}
