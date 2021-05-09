//
//  MDObject.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an object returned by the MangaDex API
public struct MDObject<T: Decodable>: Decodable {

    /// This object's ID
    public let objectId: String

    /// The kind of object encoded
    public let objectType: MDObjectType

    /// The data returned by the API
    ///
    /// This is decoded as one of MangaDexLib's structures for ease of use
    public let data: T

}

extension MDObject {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case objectType = "type"
        case data = "attributes"
    }

}
