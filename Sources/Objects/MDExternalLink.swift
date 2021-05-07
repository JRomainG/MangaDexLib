//
//  MDResource.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing external links that MangaDex provides
public struct MDExternalLink: Decodable {

    /// The type of link that this is
    public let linkType: MDExternalLinkType

    /// The name of this type of external link
    public let name: String?

    /// The URL for this external link
    public let linkURL: URL?

}

extension MDExternalLink {

    /// Custom `init` implementation to flatten the JSON and convert it to meaningful parameters
    public init(from decoder: Decoder) throws {
        linkType = MDExternalLinkType(rawValue: decoder.codingPath.first!.stringValue) ?? .raw
        let value = try decoder.singleValueContainer().decode(String.self)

        switch linkType {
        case .aniList:
            name = "AniList"
            linkURL = URL(string: "https://anilist.co/manga/\(value)")
        case .animePlanet:
            name = "Anime-Planet"
            linkURL = URL(string: "https://www.anime-planet.com/manga/\(value)")
        case .kitsu:
            name = "Kitsu"
            linkURL = URL(string: "https://kitsu.io/manga/\(value)")
        case .mangaUpdates:
            name = "MangaUpdates"
            linkURL = URL(string: "https://www.mangaupdates.com/series.html?id=\(value)")
        case .myAnimeList:
            name = "MyAnimeList"
            linkURL = URL(string: "https://myanimelist.net/manga/\(value)")
        case .novelUpdates:
            name = "NovelUpdates"
            linkURL = URL(string: "https://www.novelupdates.com/series/\(value)")
        case .bookWalker:
            name = "CDJapan"
            linkURL = URL(string: "https://bookwalker.jp/\(value)")
        case .amazon:
            name = "Amazon"
            linkURL = URL(string: value)
        case .eBookJapan:
            name = "eBookJapan"
            linkURL = URL(string: value)
        case .cdJapan:
            name = "CDJapan"
            linkURL = URL(string: value)
        case .officialTranslation:
            name = "Official translation"
            linkURL = URL(string: value)
        case .raw:
            name = nil
            linkURL = URL(string: value)
        }
    }

}
