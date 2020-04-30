//
//  MDResource.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing external resources with manga details that MangaDex links to
public class MDResource: NSObject {

    /// The name of the resource
    public let name: String

    /// The base URL of the resouce, if necessary
    public let baseURL: String?

    /// The key used by MangaDex for this resource
    public let key: String?

    /// Convenience init to create an `MDResource` instance
    init(name: String, baseURL: String?, key: String) {
        self.name = name
        self.baseURL = baseURL
        self.key = key
    }

    /// Get the `MDResource` with the given key
    static func getResource(for key: String) -> MDResource? {
        return MDResource.all.first(where: { (resource) -> Bool in
            return resource.key == key
        })
    }

}

extension MDResource {

    // Informative websites
    public static let aniList = MDResource(name: "AniList",
                                           baseURL: "https://anilist.co/manga/",
                                           key: "al")

    public static let animePlanet = MDResource(name: "Anime-Planet",
                                               baseURL: "https://www.anime-planet.com/manga/",
                                               key: "ap")

    public static let kitsu = MDResource(name: "Kitsu",
                                         baseURL: "https://kitsu.io/manga/",
                                         key: "kt")

    public static let mangaUpdates = MDResource(name: "MangaUpdates",
                                                baseURL: "https://www.mangaupdates.com/series.html?id=",
                                                key: "mu")

    public static let myAnimeList = MDResource(name: "MyAnimeList",
                                               baseURL: "https://myanimelist.net/manga/",
                                               key: "mal")

    public static let novelUpdates = MDResource(name: "NovelUpdates",
                                                baseURL: "https://www.novelupdates.com/series/",
                                                key: "nu")

    // Official releases
    public static let raw = MDResource(name: "Raw",
                                       baseURL: nil,
                                       key: "raw")

    public static let officialTranslation = MDResource(name: "",
                                                       baseURL: nil,
                                                       key: "")

    // Retail websites
    public static let amazon = MDResource(name: "Amazon",
                                          baseURL: nil,
                                          key: "amz")

    public static let eBookJapan = MDResource(name: "eBookJapan",
                                              baseURL: nil,
                                              key: "ebj")

    public static let cdJapan = MDResource(name: "CDJapan",
                                           baseURL: nil,
                                           key: "cdj")

    public static let bookWalker = MDResource(name: "Bookwalker",
                                              baseURL: "https://bookwalker.jp/",
                                              key: "bw")

    public static let all: [MDResource] = [
        .aniList,
        .animePlanet,
        .kitsu,
        .mangaUpdates,
        .myAnimeList,
        .novelUpdates,
        .raw,
        .officialTranslation,
        .amazon,
        .eBookJapan,
        .cdJapan,
        .bookWalker
    ]

}
