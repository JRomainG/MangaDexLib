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

    /// The existing type of resources MangaDex links to
    public enum ResourceType: String {
        case aniList = "al"
        case animePlanet = "ap"
        case kitsu = "kt"
        case mangaUpdates = "mu"
        case myAnimeList = "mal"
        case novelUpdates = "nu"
        case raw = "raw"
        case officialTranslation
        case amazon = "amz"
        case eBookJapan = "ebj"
        case cdJapan = "cdj"
        case bookWalker = "bw"
    }

    /// The name of the resource
    public let name: String

    /// The base URL of the resouce, if necessary
    public let baseURL: String?

    /// The key used by MangaDex for this resource
    public let key: String?

    /// The type of resource this is
    public let type: ResourceType?

    /// The identifier used to link to this resource
    public var resourceId: String?

    /// Convenience init to create an `MDResource` instance
    init(name: String, baseURL: String?, type: ResourceType) {
        self.name = name
        self.baseURL = baseURL
        self.key = type.rawValue
        self.type = type
    }

    /// Convenience init to create an `MDResource` with the given key and ID
    ///
    /// This will attempt to find the associated resource among MDResource.all,
    /// and will default to a resource with an empty baseURL
    init(key: String, resourceId: String) {
        let base = MDResource.getResource(for: key)
        self.name = base.name
        self.baseURL = base.baseURL
        self.type = base.type
        self.key = key
        self.resourceId = resourceId
    }

    /// Get the `MDResource` with the given key
    ///
    /// - Note: If the key is unknown, it defaults to `officialTranslation`
    static func getResource(for key: String) -> MDResource {
        let resource = MDResource.all.first(where: { (resource) -> Bool in
            return resource.key == key
        })
        return resource ?? .officialTranslation
    }

    /// A method to build the full URL for this resource, if it has an id
    public func getUrl() -> URL? {
        guard let path = resourceId else {
            return nil
        }
        return MDPath.externalResource(resource: self, path: path)
    }

}

extension MDResource {

    // Informative websites
    static let aniList = MDResource(name: "AniList",
                                    baseURL: "https://anilist.co/manga/",
                                    type: .aniList)

    static let animePlanet = MDResource(name: "Anime-Planet",
                                        baseURL: "https://www.anime-planet.com/manga/",
                                        type: .animePlanet)

    static let kitsu = MDResource(name: "Kitsu",
                                  baseURL: "https://kitsu.io/manga/",
                                  type: .kitsu)

    static let mangaUpdates = MDResource(name: "MangaUpdates",
                                         baseURL: "https://www.mangaupdates.com/series.html?id=",
                                         type: .mangaUpdates)

    static let myAnimeList = MDResource(name: "MyAnimeList",
                                        baseURL: "https://myanimelist.net/manga/",
                                        type: .myAnimeList)

    static let novelUpdates = MDResource(name: "NovelUpdates",
                                         baseURL: "https://www.novelupdates.com/series/",
                                         type: .novelUpdates)

    // Official releases
    static let raw = MDResource(name: "Raw",
                                baseURL: nil,
                                type: .raw)
    
    static let officialTranslation = MDResource(name: "",
                                                baseURL: nil,
                                                type: .officialTranslation)

    // Retail websites
    static let amazon = MDResource(name: "Amazon",
                                   baseURL: nil,
                                   type: .amazon)

    static let eBookJapan = MDResource(name: "eBookJapan",
                                       baseURL: nil,
                                       type: .eBookJapan)

    static let cdJapan = MDResource(name: "CDJapan",
                                    baseURL: nil,
                                    type: .cdJapan)

    static let bookWalker = MDResource(name: "Bookwalker",
                                       baseURL: "https://bookwalker.jp/",
                                       type: .bookWalker)

    static let all: [MDResource] = [
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
