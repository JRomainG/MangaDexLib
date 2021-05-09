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

    /// Get a random manga
    /// - Parameter info: The `MDManga` to create
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createManga(info: MDManga, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
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
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateManga(info: MDManga, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Delete the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Follow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func followManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Unfollow the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func unfollowManga(mangaId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Add the specified manga to the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func addMangaToCustomList(mangaId: String, listId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Remove the specified manga from the logged-in user's custom list
    /// - Parameter mangaId: The id of the manga
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func removeMangaFromCustomList(mangaId: String,
                                          listId: String,
                                          completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Get the specified manga's feed (aka its list of chapters)
    /// - Parameter mangaId: The id of the manga
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaFeed(mangaId: String, completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getMangaFeed(mangaId: mangaId)
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

    /// Get all of the logged-in user's reading statuses
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getReadingStatuses(completion: @escaping (MDReadingStatuses?, MDApiError?) -> Void) {
        let url = MDPath.getReadingStatuses()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the logged-in user's reading status for the specified manga
    /// - Parameter mangaId: The id of the manga
    /// - Parameter status: The new reading status
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateMangaReadingStatus(mangaId: String,
                                         status: MDReadingStatus,
                                         completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

}
