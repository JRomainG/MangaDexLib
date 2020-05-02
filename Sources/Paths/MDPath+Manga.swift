//
//  MDPath+Manga.swift
//  MangaDexLib-iOS
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to fetch the sorted list of mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Returns: The MangaDex URL
    public static func listedMangas(page: Int, sort: MDSortOrder) -> URL {
        return buildUrl(for: .listedMangas, with: [sort.rawValue, page])
    }

    /// Build the URL to fetch the featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    public static func featuredMangas() -> URL {
        return buildUrl(for: .featuredMangas)
    }

    /// Build the URL to fetch the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    public static func latestMangas(page: Int) -> URL {
        return buildUrl(for: .latestMangas, with: [page])
    }

    /// Build the URL to fetch the latest released chapters or updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter type: The type of resource to fetch should be (`.chapters` or `.manga`)
    /// - Parameter status: The status of the manga for which to fetch the resource (shouldn't be `.unfollowed`)
    /// - Returns: The MangaDex URL
    public static func latestFollowed(page: Int, type: ResourceType, status: MDReadingStatus) -> URL {
        let readingStatus = String(status.rawValue)
        return buildUrl(for: .latestFollowed, with: [type.rawValue, readingStatus, String(page)])
    }

    /// Build the URL to get a random manga
    public static func randomManga() -> URL {
        return buildUrl(for: .randomManga)
    }

    /// Build the URL to get the user's history
    public static func history() -> URL {
        return buildUrl(for: .history)
    }

    /// Build the URL to fetch a given manga's detail page
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter mangaTitle: The title of the manga (not strictly necessary)
    /// - Returns: The MangaDex URL
    public static func mangaDetails(mangaId: Int, mangaTitle: String?) -> URL {
        // Adding the title isn't necessary, but we can do it anyways to be consistent
        let components: [String] = [String(mangaId), getNormalizedString(from: mangaTitle)]
        return buildUrl(for: .mangaPage, with: components)
    }

    /// Build the URL to fetch a given manga's comments
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter mangaTitle: The title of the manga (not strictly necessary)
    /// - Returns: The MangaDex URL
    public static func mangaComments(mangaId: Int, mangaTitle: String?) -> URL {
        // The title doesn't really matter, but let's try to make it nice either way
        let normalizedTitle = getNormalizedString(from: mangaTitle, defaultString: MDApi.defaultUserAgent)
        let components: [String] = [String(mangaId), normalizedTitle, ResourceType.comments.rawValue]
        return buildUrl(for: .mangaPage, with: components)
    }

    /// Build the URL to fetch a given manga's chapters
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter mangaTitle: The title of the manga (not strictly necessary)
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    public static func mangaChapters(mangaId: Int, mangaTitle: String?, page: Int) -> URL {
        // The title doesn't really matter, but let's try to make it nice either way
        let normalizedTitle = getNormalizedString(from: mangaTitle, defaultString: MDApi.defaultUserAgent)
        let components: [String] = [String(mangaId), normalizedTitle, ResourceType.chapters.rawValue, String(page)]
        return buildUrl(for: .mangaPage, with: components)
    }

    /// Build the URL to fetch information about a given manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Returns: The MangaDex URL
    public static func mangaInfo(mangaId: Int) -> URL {
        let params = [
            URLQueryItem(name: ApiParam.id.rawValue, value: String(mangaId)),
            URLQueryItem(name: ApiParam.type.rawValue, value: ResourceType.manga.rawValue)
        ]
        return MDPath.buildUrl(for: .api, with: params)
    }

}
