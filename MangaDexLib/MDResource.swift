//
//  MDResource.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing external resources with manga details that MangaDex links to
class MDResource: NSObject {

    /// The name of the resource
    let name: String

    /// The base URL of the resouce, if necessary
    let baseURL: String?

    /// The key used by MangaDex for this resource
    let key: String?

    /// Convenience init to create an `MDResource` instance
    init(name: String, baseURL: String?, key: String) {
        self.name = name
        self.baseURL = baseURL
        self.key = key
    }

    /// Get the `MDResource` with the given key
    static func getResource(for key: String) -> MDResource? {
        return MDResource.all.filter { (resource) -> Bool in
            return resource.key == key
        }.first
    }

}

extension MDResource {

    // Informative websites
    static let aniList = MDResource(name: "AniList",
                                    baseURL: "https://anilist.co/manga/",
                                    key: "al")

    static let animePlanet = MDResource(name: "Anime-Planet",
                                        baseURL: "https://www.anime-planet.com/manga/",
                                        key: "ap")

    static let kitsu = MDResource(name: "Kitsu",
                                  baseURL: "https://kitsu.io/manga/",
                                  key: "kt")

    static let mangaUpdates = MDResource(name: "MangaUpdates",
                                         baseURL: "https://www.mangaupdates.com/series.html?id=",
                                         key: "mu")

    static let myAnimeList = MDResource(name: "MyAnimeList",
                                        baseURL: "https://myanimelist.net/manga/",
                                        key: "mal")

    // Official releases
    static let raw = MDResource(name: "Raw",
                                baseURL: nil,
                                key: "raw")

    static let officialTranslation = MDResource(name: "",
                                                baseURL: nil,
                                                key: "")

    // Retail websites
    static let amazon = MDResource(name: "Amazon",
                                   baseURL: nil,
                                   key: "amz")

    static let eBookJapan = MDResource(name: "eBookJapan",
                                       baseURL: nil,
                                       key: "ebj")

    static let cdJapan = MDResource(name: "CDJapan",
                                    baseURL: nil,
                                    key: "cdj")

    static let bookWalker = MDResource(name: "Bookwalker",
                                       baseURL: "https://bookwalker.jp/",
                                       key: "bw")

    static let all: [MDResource] = [
        .aniList,
        .animePlanet,
        .kitsu,
        .mangaUpdates,
        .myAnimeList,
        .raw,
        .officialTranslation,
        .amazon,
        .eBookJapan,
        .cdJapan,
        .bookWalker
    ]

}
