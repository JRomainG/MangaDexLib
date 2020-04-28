//
//  MDChapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a manga chapter returned by MangaDex
struct MDChapter: Decodable {

    /// The id of the chapter
    var chapterId: Int

    /// The id of the manga this chapter belongs to
    var mangaId: Int?

    /// The chapter's title
    var title: String?

    /// The chapter's hash, used to fetch the pages
    var hash: String?

    /// The volume this chapter belongs to
    var volume: String?

    /// The chapter in the printed manga which corresponds to this chapter
    var chapter: String?

    /// The list of page file names
    var pages: [String]?

    /// The id of the main group that worked on this chapter
    var groupId: Int?

    /// The id of another group that worked on this chapter
    var groupId2: Int?

    /// The id of another group that worked on this chapter
    var groupId3: Int?

    /// The name of the main group that worked on this chapter
    var groupName: String?

    /// The name of another group that worked on this chapter
    var groupName2: String?

    /// The name of another group that worked on this chapter
    var groupName3: String?

    /// The Unix timestamp this chapter was release
    ///
    /// This may be in the future if the group imposes a delay, and the chapter
    /// is not yet available on MangaDex
    var timestamp: UInt?

    /// The name of the chapter's original language
    var originalLangName: String?

    /// The short name of the chapter's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    var originalLangCode: String?

    /// The number of comments for this chapter
    var comments: Int?

    /// The base URL of the server from which to retreive the pages
    var server: String?

    /// A boolean indicating whether this chapter is read in a long strip
    ///
    /// Most webtoons are read as one long strip, without seperate pages
    var longStrip: Bool?

    /// This chapter's status
    var status: MDStatus?

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
        case mangaId
        case title
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
        case timestamp
        case originalLangName = "lang_name"
        case originalLangCode = "lang_code"
        case comments
        case server
        case longStrip = "long_strip"
        case status
    }

}
