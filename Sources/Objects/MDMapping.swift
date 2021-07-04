//
//  MDMapping.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a mapping between a legacy ID and a new ID
/// This is passed in the `data` property of an `MDObject`
public struct MDMapping: Decodable {

    /// The type of object mapped
    public let type: MDObjectType

    /// The legacy ID of the object
    public let legacyId: Int

    /// The new ID of the object
    public let newId: String

}

/// Structure representing a query for the API to convert legacy IDs into new IDs
public struct MDMappingQuery: Encodable {

    /// The type of object mapped
    public let type: MDObjectType

    /// The list of legacy object IDs
    public let ids: [Int]

    /// Convenience init to ask for a mapping
    public init(objectType: MDObjectType, legacyIds: [Int]) {
        type = objectType
        ids = legacyIds
    }

}
