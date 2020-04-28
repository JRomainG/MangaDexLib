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
    let chapterId: Int

    /// The id of the manga this chapter belongs to
    let mangaId: Int

    /// The chapter's title
    let title: String

    /// The chapter's hash, used to fetch the pages
    let hash: String

    /// The volume this chapter belongs to
    let volume: String?

    /// The chapter in the printed manga which corresponds to this chapter
    let chapter: String?

    /// The list of page file names
    let pages: [String]

    /// The id of the main group that worked on this chapter
    let groupId: Int

    /// The id of another group that worked on this chapter
    let groupId2: Int?

    /// The id of another group that worked on this chapter
    let groupId3: Int?

    /// The name of the main group that worked on this chapter
    let groupName: String?

    /// The name of another group that worked on this chapter
    let groupName2: String?

    /// The name of another group that worked on this chapter
    let groupName3: String?

    /// The Unix timestamp this chapter was release
    ///
    /// This may be in the future if the group imposes a delay, and the chapter
    /// is not yet available on MangaDex
    let timestamp: UInt

    /// The name of the chapter's original language
    var originalLangName: String?

    /// The short name of the chapter's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    var originalLangCode: String?

    /// The number of comments for this chapter
    let comments: Int?

    /// The base URL of the server from which to retreive the pages
    let server: String?

    /// A boolean indicating whether this chapter is read in a long strip
    ///
    /// Most webtoons are read as one long strip, without seperate pages
    let longStrip: Bool?

    /// The status of this chapter
    ///
    /// Should be `OK`, but can be `deleted`
    let status: MDStatus?

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
