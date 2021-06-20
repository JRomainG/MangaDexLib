//
//  MDApi+Manga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 09/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of latest updated mangas
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaList(completion: @escaping (MDResultList<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getMangaList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Search the list of chapters using the specified filter
    /// - Parameter filter: The filter to use
    /// - Parameter completion: The completion block called once the request is done
    public func searchMangas(filter: MDMangaFilter,
                             completion: @escaping (MDResultList<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getMangaList(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of existing tags for mangas
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaTagList(completion: @escaping ([MDResult<MDTag>]?, MDApiError?) -> Void) {
        let url = MDPath.getMangaTagList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get a random manga
    /// - Parameter completion: The completion block called once the request is done
    public func getRandomManga(completion: @escaping (MDResult<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getRandomManga()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Create a new manga with the specified information
    /// - Parameter info: The manga information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createManga(info: MDManga, completion: @escaping (MDResult<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.createManga()
        performBasicPostCompletion(url: url, data: info, completion: completion)
    }

    /// View the specified manga's information
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    public func viewManga(mangaId: String, completion: @escaping (MDResult<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.viewManga(mangaId: mangaId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified manga's information
    /// - Parameter mangaId: The id of the manga
    /// - Parameter info: The manga information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateManga(mangaId: String,
                            info: MDManga,
                            completion: @escaping (MDResult<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.updateManga(mangaId: mangaId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }

    /// Delete the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteManga(mangaId: mangaId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

    /// Follow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func followManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.followManga(mangaId: mangaId)
        performPost(url: url, body: "") { (response) in
            completion(response.error)
        }
    }

    /// Unfollow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func unfollowManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.unfollowManga(mangaId: mangaId)
        performPost(url: url, body: "") { (response) in
            completion(response.error)
        }
    }

    /// Add the specified manga to the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func addMangaToCustomList(mangaId: String, listId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.addMangaToCustomList(mangaId: mangaId, listId: listId)
        performPost(url: url, body: "") { (response) in
            completion(response.error)
        }
    }

    /// Remove the specified manga from the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func removeMangaFromCustomList(mangaId: String,
                                          listId: String,
                                          completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.removeMangaFromCustomList(mangaId: mangaId, listId: listId)
        performPost(url: url, body: "") { (response) in
            completion(response.error)
        }
    }

    /// Get the specified manga's feed (aka its list of chapters)
    /// - Parameter mangaId: The id of the manga
    /// - Parameter filter: The filter to apply
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaFeed(mangaId: String,
                             filter: MDFeedFilter? = nil,
                             completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getMangaFeed(mangaId: mangaId, filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the specified manga's aggregation of volumes and chapters
    /// - Parameter mangaId: The id of the manga
    /// - Parameter languages: The list of translated languages to filter on
    /// - Returns: The MangaDex URL
    public func getMangaVolumesAndChapters(mangaId: String,
                                           languages: [Locale]? = nil,
                                           completion: @escaping (MDAggregate?, MDApiError?) -> Void) {
        var langCodes: [String] = []
        for locale in languages ?? [] {
            langCodes.append(locale.languageCode!)
        }
        let url = MDPath.getMangaVolumesAndChapters(mangaId: mangaId, languages: langCodes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get a list of chapter ids that are marked as read for the specified manga and the logged-in user
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getMangaReadMarkers(mangaId: String,
                                    completion: @escaping (MDReadMarkers?, MDApiError?) -> Void) {
        let url = MDPath.getMangaReadMarkers(mangaId: mangaId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get a list of chapter ids that are marked as read for the specified mangas and the logged-in user
    /// - Parameter mangaIds: The list of manga ids
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getMangasReadMarkers(mangaIds: [String],
                                     completion: @escaping (MDReadMarkers?, MDApiError?) -> Void) {
        let url = MDPath.getMangasReadMarkers(mangaIds: mangaIds)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get all of the logged-in user's reading statuses
    /// - Parameter filter: The filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getReadingStatuses(filter: MDReadingStatus? = nil,
                                   completion: @escaping (MDReadingStatuses?, MDApiError?) -> Void) {
        let url = MDPath.getReadingStatuses(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get all of the logged-in user's reading statuses
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getMangaReadingStatus(mangaId: String,
                                      completion: @escaping (MDReadingStatus?, MDApiError?) -> Void) {
        let url = MDPath.getMangaReadingStatus(mangaId: mangaId)
        performGet(url: url) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }

            // Parse the response to retreive the list of objects
            do {
                let data = try MDParser.parse(json: response.content, type: [String: String?].self)
                guard let rawStatus = data["status"] as? String else {
                    // Status may be nil if the user hasn't set anything for this manga
                    completion(nil, nil)
                    return
                }
                let status = MDReadingStatus(rawValue: rawStatus)
                completion(status, nil)
            } catch {
                let error = MDApiError(type: .decodingError, body: response.content, error: error)
                completion(nil, error)
            }
        }
    }

    /// Update the logged-in user's reading status for the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter status: The new reading status
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    /// - Note: Setting the reading status to `nil` will remove it
    public func updateMangaReadingStatus(mangaId: String,
                                         status: MDReadingStatus?,
                                         completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.updateMangaReadingStatus(mangaId: mangaId)
        let data: [String: String?] = [
            "status": status?.rawValue
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

}
