//
//  MDApiResponse.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// MangaDex's API returns both the info about a manga, and a list of its chapters
/// when fetching info about a manga, so this structure helps reflect the way the
/// data is stored in their response.
/// Only `MDManga` and `MDChapter` objects should be returned to the user
struct MDApiManga: Decodable {

    /// The manga stored in this API response
    var manga: MDManga

    /// The list of chapters stored in this API response
    var chapters: [Int: MDChapter]

    /// The status of the manga stored in this API response
    var status: MDStatus

    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case manga
        case chapters = "chapter"
        case status
    }

}
