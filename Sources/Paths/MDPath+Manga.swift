//
//  MDPath+Manga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of manga
    /// - Parameter filter: The filter to apply
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func getMangaList(filter: MDMangaFilter? = nil, includes: [MDObjectType]? = nil) -> URL {
        var params = filter?.getParameters() ?? []
        params += MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .manga, params: params)
    }

    /// Build the URL to get the list of existing tags for manga
    /// - Returns: The MangaDex URL
    static func getMangaTagList() -> URL {
        return buildUrl(for: .manga, with: ["tag"])
    }

    /// Build the URL to get a random manga
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func getRandomManga(includes: [MDObjectType]? = nil) -> URL {
        let params = MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .manga, with: ["random"], params: params)
    }

    /// Build the URL to create a new manga
    /// - Returns: The MangaDex URL
    static func createManga() -> URL {
        return buildUrl(for: .manga)
    }

    /// Build the URL to get the specified manga's volumes and chapters
    /// - Parameter mangaId: The id of the manga
    /// - Parameter languages: The list of translated languages to filter on
    /// - Returns: The MangaDex URL
    static func getMangaVolumesAndChapters(mangaId: String, languages: [String]) -> URL {
        let params = MDPath.formatQueryItem(name: "translatedLanguage", array: languages)
        return buildUrl(for: .manga, with: [mangaId, "aggregate"], params: params)
    }

    /// Build the URL to view the specified manga's information
    /// - Parameter mangaId: The id of the manga
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func viewManga(mangaId: String, includes: [MDObjectType]? = nil) -> URL {
        let params = MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .manga, with: [mangaId], params: params)
    }

    /// Build the URL to update the specified manga's information
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func updateManga(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId])
    }

    /// Build the URL to delete the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func deleteManga(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId])
    }

    /// Build the URL to follow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func followManga(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, "follow"])
    }

    /// Build the URL to unfollow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func unfollowManga(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, "follow"])
    }

    /// Build the URL to add the specified manga to the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Returns: The MangaDex URL
    static func addMangaToCustomList(mangaId: String, listId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, listId])
    }

    /// Build the URL to remove the specified manga from the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Returns: The MangaDex URL
    static func removeMangaFromCustomList(mangaId: String, listId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, listId])
    }

    /// Build the URL to get the specified manga's feed
    /// - Parameter mangaId: The id of the manga
    /// - Parameter filter: The filter to apply
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func getMangaFeed(mangaId: String, filter: MDFeedFilter? = nil, includes: [MDObjectType]? = nil) -> URL {
        var params = filter?.getParameters() ?? []
        params += MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .manga, with: [mangaId, "feed"], params: params)
    }

    /// Build the URL to get a list of chapter ids that are marked as read for the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func getMangaReadMarkers(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, "read"])
    }

    /// Build the URL to get a list of chapter ids that are marked as read for the specified mangas
    /// - Parameter mangaIds: The list of manga ids
    /// - Returns: The MangaDex URL
    static func getMangasReadMarkers(mangaIds: [String]) -> URL {
        let params = MDPath.formatQueryItem(name: "ids", array: mangaIds)
        return buildUrl(for: .manga, with: ["read"], params: params)
    }

    /// Build the URL to get all of the logged-in user's reading statuses
    /// - Parameter filter: An optional filter to only return mangas with the specified status
    /// - Returns: The MangaDex URL
    static func getReadingStatuses(filter: MDReadingStatus? = nil) -> URL {
        let params = [URLQueryItem(name: "status", value: filter?.rawValue)]
        return buildUrl(for: .manga, with: ["status"], params: params)
    }

    /// Build the URL to get the specified manga's feed
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func getMangaReadingStatus(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, "status"])
    }

    /// Build the URL to update the logged-in user's reading status for the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Returns: The MangaDex URL
    static func updateMangaReadingStatus(mangaId: String) -> URL {
        return buildUrl(for: .manga, with: [mangaId, "status"])
    }

}
