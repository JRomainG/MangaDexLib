//
//  MDChapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a manga chapter returned by MangaDex
public struct MDChapter: Decodable {

    /// The id of the chapter
    public var chapterId: Int?

    /// The id of the manga this chapter belongs to
    public var mangaId: Int?

    /// The chapter's title
    public var title: String?

    /// Whether this chapter was read or not
    ///
    /// This is only extracted when fetching a list of chapters, as MangaDex's
    /// json API does not export this value
    /// - Note: Calls to `MDApi.getChapterInfo` will NOT set this value
    public var read: Bool?

    /// The chapter's hash, used to fetch the pages
    public var hash: String?

    /// The volume this chapter belongs to
    public var volume: String?

    /// The chapter in the printed manga which corresponds to this chapter
    public var chapter: String?

    /// The list of page file names
    public var pages: [String]?

    /// The id of the main group that worked on this chapter
    public var groupId: Int?

    /// The id of another group that worked on this chapter
    public var groupId2: Int?

    /// The id of another group that worked on this chapter
    public var groupId3: Int?

    /// The name of the main group that worked on this chapter
    public var groupName: String?

    /// The name of another group that worked on this chapter
    public var groupName2: String?

    /// The name of another group that worked on this chapter
    public var groupName3: String?

    /// The website of the group that released this chapter
    ///
    /// Usually shown when a chapter is in the `pending` state
    public var groupWebsite: String?

    /// The Unix timestamp this chapter was release
    ///
    /// This may be in the future if the group imposes a delay, and the chapter
    /// is not yet available on MangaDex
    public var timestamp: UInt?

    /// The name of the chapter's original language
    public var originalLangName: String?

    /// The short name of the chapter's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    public var originalLangCode: String?

    /// The chapter's original language
    ///
    /// - Note: This may be `nil` even if `originalLangCode` isn't
    /// In that case, you can manually fetch the language using the
    /// `MDLanguageCodes` dict
    public var originalLang: MDLanguage?

    /// The number of comments for this chapter
    public var nbrComments: Int?

    /// The base URL of the server from which to retreive the pages
    public var server: String?

    /// A boolean indicating whether this chapter is read in a long strip
    ///
    /// Most webtoons are read as one long strip, without seperate pages
    public var longStrip: Int?

    /// This chapter's status
    public var status: MDStatus?

    /// A convenience method to create an empty chapter
    init() {
    }

    /// A convenience method to create a chapter with only an id
    init(chapterId: Int) {
        self.chapterId = chapterId
    }

    /// A convenience method to create a chapter with a title and id only
    init(title: String, chapterId: Int) {
        self.title = title
        self.chapterId = chapterId
    }

}

extension MDChapter {

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case chapterId = "id"
        case mangaId = "manga_id"
        case title
        case read
        case hash
        case volume
        case chapter
        case pages = "page_array"
        case groupId = "group_id"
        case groupId2 = "group_id_2"
        case groupId3 = "group_id_3"
        case groupName = "group_name"
        case groupName2 = "group_name_2"
        case groupName3 = "group_name_3"
        case groupWebsite = "group_website"
        case timestamp
        case originalLangName = "lang_name"
        case originalLangCode = "lang_code"
        case originalLang
        case nbrComments = "comments"
        case server
        case longStrip = "long_strip"
        case status
    }

    /// Cast the given value to the right type, base on the given CodingKey
    /// - Parameter value: The value to cast
    /// - Parameter jsonKey: The `CodingKeys` value corresponding to the value
    ///
    /// - Note: Only the attributes used by the parser are copied here
    static func decodeValue(_ value: String, for key: CodingKeys) -> Any? {
        switch key {
        case .chapterId, .mangaId, .groupId, .timestamp, .nbrComments:
            return Int(value)
        case .read:
            return Bool(value)
        case .originalLang:
            // No need to cast further, as it will be encoded to json anyway
            return Int(value)
        default:
            return value
        }
    }

}
