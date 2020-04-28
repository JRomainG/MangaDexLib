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

    /// The link to the manga's cover image
    var coverUrl: String?

    /// The manga's publication status
    var publicationStatus: MDPublicationStatus?

    /// The manga's genres
    var genres: [MDGenre]?

    /// A boolean indicating whether the last chapter of the manga has been uploaded
    var lastChapter: Bool?

    /// The name of the manga's original language
    var originalLangName: String?

    /// The short name of the manga's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    var originalLangCode: String?

    /// A boolean indicating whether the manga is rated or not
    var rated: Bool?

    /// A set of links to external websites
    var links: [String: String]?

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
        case coverUrl = "conver_url"
        case publicationStatus = "status"
        case genres
        case lastChapter = "last_chapter"
        case originalLangName = "lang_name"
        case originalLangCode = "lang_flag"
        case rated = "hentai"
        case links
    }

}
