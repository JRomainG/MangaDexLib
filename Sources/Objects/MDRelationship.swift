//
//  MDRelationship.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an relationship info returned by the MangaDex API
public struct MDRelationship: Decodable {

    /// The ID of the object referenced by this relationship
    public let objectId: String

    /// The kind of object referenced by this relationship
    public let objectType: MDObjectType

}

extension MDRelationship {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case objectType = "type"
    }

}
