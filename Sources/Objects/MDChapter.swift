//
//  MDChapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a manga chapter returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDChapter: Decodable {

    /// The chapter's title
    public let title: String

    /// The volume this chapter belongs to, if entered by the uploader
    public let volume: Int?

    /// The chapter in the printed manga which corresponds to this chapter
    /// - Note: This may be an empty string if the uploader did not provide a chapter number (e.g. for oneshots)
    public let chapter: String?

    /// The language in which this chapter was translated
    public let language: Locale?

    /// The chapter's hash, used to fetch the pages when using MangaDex@Home
    public let hash: String

    /// The list of page file names
    ///
    /// Use `getPageUrls` to get the list of URLs for these files
    public let pages: [String]

    /// The list of low resolution page file names
    ///
    /// Use `getPageUrls` and set the `lowRes` parameter to `true` to get the list of URLs for these files
    public let pagesLowRes: [String]

    /// The date at which this chapter entry was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this chapter entry on MangaDex
    /// - Note: This property will be `nil` if the chapter was never modified after being created
    public let updatedDate: Date?

    /// The date at which this chapter will be or has been published
    /// - Note: This may differ from the `createdDate` property as scanlation groups might impose delays
    public let publishDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDChapter {

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case title
        case volume
        case chapter
        case language = "translatedLanguage"
        case hash
        case pages = "data"
        case pagesLowRes = "dataSaver"
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case publishDate = "publishAt"
        case version
    }

    /// Custom `init` implementation to handle decoding the `language` attribute
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        volume = try container.decode(Int?.self, forKey: .volume)
        chapter = try container.decode(String?.self, forKey: .chapter)
        hash = try container.decode(String.self, forKey: .hash)
        pages = try container.decode([String].self, forKey: .pages)
        pagesLowRes = try container.decode([String].self, forKey: .pagesLowRes)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        updatedDate = try container.decode(Date?.self, forKey: .updatedDate)
        publishDate = try container.decode(Date?.self, forKey: .publishDate)
        version = try container.decode(Int.self, forKey: .version)

        // Manually decode the language code to convert it from a String to a Locale
        if let langCode = try container.decode(String?.self, forKey: .language) {
            language = Locale.init(identifier: langCode)
        } else {
            language = nil
        }
    }

}
