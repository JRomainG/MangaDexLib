//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a manga returned by MangaDex
struct MDManga: Codable {

    /// The id of the manga
    var id: Int?

    /// The link to the manga's cover image
    var coverUrl: String?

    /// The manga's description
    var description: String?

    /// The manga's title
    var title: String?

    /// The artist working on the manga
    var artist: String?

    /// The author of the manga
    var author: String?

    /// The manga's publication status
    var status: MDPublicationStatus?

    /// The manga's genres
    var genres: [MDGenre]?

    /// A boolean indicating whether the last chapter of the manga has been uploaded
    var lastChapter: Bool?

    /// The name of the manga's original language
    var langName: String?

    /// The short name of the manga's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    var langFlag: String?

    /// A boolean indicating whether the manga is rated or not
    var hentai: Bool?

    /// A set of links to external websites
    var links: [String: String]?

    /// A convenience method to create a manga with only an id
    init(id: Int) {
        self.id = id
    }

    /// A convenience method to create a manga with a title and id only
    init(title: String, id: Int) {
        self.title = title
        self.id = id
    }

}
