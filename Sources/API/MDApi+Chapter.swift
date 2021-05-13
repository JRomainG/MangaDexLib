//
//  MDApi+Chapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 10/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of latest published chapters
    /// - Parameter completion: The completion block called once the request is done
    public func getChapterList(completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getChapterList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Search the list of chapters using the specified filter
    /// - Parameter filter: The filter to use
    /// - Parameter completion: The completion block called once the request is done
    public func searchChapters(filter: MDChapterFilter,
                               completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.searchChapters(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    public func viewChapter(chapterId: String, completion: @escaping (MDResult<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.viewChapter(chapterId: chapterId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified chapter's information
    /// - Parameter info: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateChapter(info: MDChapter, completion: @escaping (MDChapter?, MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Delete the specified chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteChapter(chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Mark the specified chapter as read
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func markChapterRead(chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Mark the specified chapter as unread
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func markChapterUnread(chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

}
