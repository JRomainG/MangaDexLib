//
//  MDResource.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing external links that MangaDex provides
public struct MDExternalLink {

    /// The type of link that this is
    public let linkType: MDExternalLinkType

    /// The value saved by MangaDex as the value (not always the full link)
    internal let rawValue: String

    /// The name of this type of external link
    public let name: String?

    /// The URL for this external link
    public let linkURL: URL?

}

extension MDExternalLink {

    // swiftlint:disable cyclomatic_complexity
    /// Custom `init` implementation to take a key/value and convert it to a proper struct
    public init(key: String, value: String) {
        linkType = MDExternalLinkType(rawValue: key) ?? .raw
        rawValue = value

        switch linkType {
        case .aniList:
            name = "AniList"
            linkURL = URL(string: "https://anilist.co/manga/\(value)")
        case .animePlanet:
            name = "Anime-Planet"
            linkURL = URL(string: "https://www.anime-planet.com/manga/\(value)")
        case .bookWalker:
            name = "BookWalker"
            linkURL = URL(string: "https://bookwalker.jp/\(value)")
        case .mangaUpdates:
            name = "MangaUpdates"
            linkURL = URL(string: "https://www.mangaupdates.com/series.html?id=\(value)")
        case .novelUpdates:
            name = "NovelUpdates"
            linkURL = URL(string: "https://www.novelupdates.com/series/\(value)")
        case .kitsu:
            // The MangaDex documentation states:
            // If integer, use id version of the URL, otherwise use slug one
            name = "Kitsu"
            if let mangaId = Int(value) {
                linkURL = URL(string: "https://kitsu.io/manga/\(mangaId)")
            } else {
                linkURL = URL(string: "https://kitsu.io/api/edge/manga?filter[slug]=\(value)")
            }
        case .amazon:
            name = "Amazon"
            linkURL = URL(string: value)
        case .eBookJapan:
            name = "eBookJapan"
            linkURL = URL(string: value)
        case .myAnimeList:
            name = "MyAnimeList"
            linkURL = URL(string: "https://myanimelist.net/manga/\(value)")
        case .raw:
            name = nil
            linkURL = URL(string: value)
        case .officialTranslation:
            name = "Official english translation"
            linkURL = URL(string: value)
        }
    }

}
