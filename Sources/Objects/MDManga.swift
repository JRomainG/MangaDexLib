//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a manga returned by MangaDex
public struct MDManga: Decodable {

    /// The id of the manga
    public var mangaId: Int?

    /// The manga's title
    public var title: String?

    /// The author of the manga
    public var author: String?

    /// The artist working on the manga
    public var artist: String?

    /// The manga's description
    public var description: String?

    /// The list of chapters for this manga
    ///
    /// Not actually stored here in the API, but more convenient for users
    public var chapters: [MDChapter]?

    /// The link to the manga's cover image
    ///
    /// - Note: This property exists only so tje JSON parsing doesn't fail,
    /// it should rather be accessed by calling `getCoverUrl()`
    private var coverUrl: String?

    /// The manga's publication status
    public var publicationStatus: MDPublicationStatus?

    /// The user-defined reading status for this manga
    public var readingStatus: MDReadingStatus?

    /// A string indicating the volume of the user's last read chapter for this manga
    ///
    /// Also see `currentChapter`
    /// - Attention: The user can provide a custom string here, even if it's not an Int
    /// - Note: This is not always automatically updated by MangaDex
    public var currentVolume: String?

    /// A string indicating the user's progress in reading this manga
    ///
    /// Also see `currentVolume`
    /// - Attention: The user can provide a custom string here, even if it's not an Int
    /// - Note: This is not always automatically updated by MangaDex
    public var currentChapter: String?

    /// The manga's tags
    public var tags: [Int]?

    /// A string indicating which chapter marks the end of the manga
    ///
    /// Equal to "0" if the last chapter hasn't been uploaded. Bonus chapters do not count
    public var lastChapter: String?

    /// The name of the manga's original language
    public var originalLangName: String?

    /// The short name of the manga's original language
    ///
    /// Ex: `jp` for Japanese, `gb` for British English
    public var originalLangCode: String?

    /// A boolean indicating whether the manga is rated or not
    ///
    /// Encoded as an integer by the API
    public var rated: Int?

    /// A set of links to external websites
    ///
    /// - Note: This property should be accessed by calling `getExternalLinks()`
    /// so they are parsed to a more usable format
    private var links: [String: String]?

    /// This manga's status
    ///
    /// Not actually stored here in the API, but more convenient for users
    public var status: MDStatus?

    /// A convenience method to create a manga with only an id
    init(mangaId: Int) {
        self.mangaId = mangaId
    }

    /// A convenience method to create a manga with a title and id only
    public init(title: String, mangaId: Int) {
        self.title = title
        self.mangaId = mangaId
    }

    /// A method to try to build the URL to a manga's cover
    public func getCoverUrl(size: MDPath.ImageFormat = .fullrez) -> URL? {
        guard let mangaId = self.mangaId else {
            return nil
        }
        return MDPath.cover(mangaId: mangaId, size: size)
    }

    /// A method to try to get the manga's original language
    public func getOriginalLang() -> MDLanguage? {
        guard let code = originalLangCode else {
            return nil
        }
        return MDLanguageCodes[code]
    }

    /// The external resources linked by MangaDex for this manga
    ///
    /// This usually includes retail websites (link Amazon, or Bookwalker)
    /// and website with information about the manga (like MangaUpdates)
    public func getExternalLinks() -> [MDResource]? {
        guard let links = self.links else {
            return nil
        }
        var resources: [MDResource] = []
        for (key, resourceId) in links {
            let resource = MDResource(key: key, resourceId: resourceId)
            resources.append(resource)
        }
        return resources
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
        case readingStatus
        case currentVolume
        case currentChapter
        case tags = "genres"
        case lastChapter = "last_chapter"
        case originalLangName = "lang_name"
        case originalLangCode = "lang_flag"
        case rated = "hentai"
        case links
        case status = "manga_status"
    }

}
