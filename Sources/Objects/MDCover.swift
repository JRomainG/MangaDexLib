//
//  MDCover.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 05/06/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a cover returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDCover {

    /// The volume this cover belongs to, if entered by the uploader
    public let volume: String?

    /// The name of the file for this cover
    ///
    /// Use `getCoverUrl` to get the url for this cover
    public let fileName: String?

    /// This cover's description, if entered by the uploader
    public let description: String?

    /// The date at which this cover entry was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this cover entry on MangaDex
    /// - Note: This property will be `nil` if the cover was never modified after being created
    public let updatedDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

    /// The URL for this cover
    /// - Parameter mangaId: The ID of the manga this cover belongs to
    public func getCoverUrl(mangaId: String, size: MDCoverSize = .original) -> URL? {
        guard let fileName = self.fileName else {
            return nil
        }
        return MDPath.getCoverUrl(mangaId: mangaId, fileName: fileName, size: size)
    }

}

extension MDCover: Decodable {

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case volume
        case fileName
        case description
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case version
    }

}

extension MDCover: Encodable {

    /// Convenience `init` used for update endpoints
    public init(volume: String,
                description: String? = nil) {
        self.volume = volume
        self.description = description

        // Unused during upload
        fileName = nil
        createdDate = .init()
        updatedDate = nil

        // Hardcoded based on the API version we support
        version = 2
    }

}
