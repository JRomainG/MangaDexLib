//
//  MDObject.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an object returned by the MangaDex API
/// This is used in relationship lists
public struct MDObject: Decodable {

    /// This object's ID
    public let objectId: String

    /// The kind of object encoded
    public let objectType: MDObjectType

    /// This object's attributes
    /// - Note: This should probably always be `nil`, otherwise the appropriate structure will be returned instead
    public let attributes: String?

}

extension MDObject {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case objectType = "type"
        case attributes
    }

}
