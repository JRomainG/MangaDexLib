//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a manga returned by MangaDex
struct MDManga: Decodable {

    /// The id of the manga
    var mangaId: Int?

    /// The manga's title
    var title: String?

    /// The author of the manga
    var author: String?

    /// The artist working on the manga
    var artist: String?

    /// The manga's description
    var description: String?

    /// The list of chapters for this manga
    ///
    /// Not actually stored here in the API, but more convenient for users
    var chapters: [MDChapter]?

    /// The link to the manga's cover image
    var coverUrl: String?

    /// The manga's publication status
    var publicationStatus: MDPublicationStatus?

    /// The manga's tags
    var tags: [Int]?

    /// A string indicating which chapter marks the end of the manga
    ///
    /// Equal to "0" if the last chapter hasn't been uploaded. Bonus chapters do not count
    var lastChapter: String?

    /// The name of the manga's original language
    var originalLangName: String?

    /// The short name of the manga's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    var originalLangCode: String?

    /// A boolean indicating whether the manga is rated or not
    ///
    /// Encoded as an integer by the API
    var rated: Int?

    /// A set of links to external websites
    var links: [String: String]?

    /// This manga's status
    ///
    /// Not actually stored here in the API, but more convenient for users
    var status: MDStatus?

    /// A convenience method to create a manga with only an id
    init(mangaId: Int) {
        self.mangaId = mangaId
    }

    /// A convenience method to create a manga with a title and id only
    init(title: String, mangaId: Int) {
        self.title = title
        self.mangaId = mangaId
    }

}

extension MDManga {

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case mangaId = "id"
        case title
        case author
        case artist
        case description
        case chapters
        case coverUrl = "cover_url"
        case publicationStatus = "status"
        case tags = "genres"
        case lastChapter = "last_chapter"
        case originalLangName = "lang_name"
        case originalLangCode = "lang_flag"
        case rated = "hentai"
        case links
        case status = "manga_status"
    }

}
