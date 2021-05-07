//
//  MDChapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a manga chapter returned by MangaDex
public struct MDChapter: Decodable {

    /// The id of the chapter
    public var chapterId: String?

    /// The chapter's title
    public let title: String

    /// The volume this chapter belongs to, if entered by the uploader
    public let volume: String?

    /// The chapter in the printed manga which corresponds to this chapter
    ///
    /// This may be an empty string if the uploader did not provide a chapter number (e.g. for oneshots)
    public let chapter: String?

    /// The language in which this chapter was translated
    public let language: Locale

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
    ///
    /// This property will be null if the chapter was never modified after being created
    public let updatedDate: Date?

    /// The date at which this chapter will be or has been published
    ///
    /// This may differ from the `createdDate` property as scanlation groups might impose delays
    public let publishDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

    /// A method to build the full URLs for a chapter's page images
    public func getPageUrls(lowRes: Bool = false) -> [URL] {
        var pageUrls: [URL] = []
        let pageFiles = lowRes ? self.pagesLowRes : self.pages
        for page in pageFiles {
            // TODO
        }
        return pageUrls
    }

}

extension MDChapter {

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case chapterId = "id"
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

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDChapter.self, forKey: .attributes)
        self.chapterId = try container.decode(String.self, forKey: .objectId)
    }

}
