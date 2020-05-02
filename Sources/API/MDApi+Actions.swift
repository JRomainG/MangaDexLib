//
//  MDApi+Actions.swift
//  MangaDexLib-iOS
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

// MARK: - MDApi Ajax Actions

extension MDApi {

    /// Perform a GET request for the given URL, formated correctly so it acts as an action
    ///
    /// - Parameter url: The URL to load to perform the given action
    /// - Parameter completion: The callback at the end of the request
    func performAction(for url: URL, completion: @escaping MDCompletion) {
        let options = MDRequestOptions(referer: nil, requestedWith: "XMLHttpRequest")
        performGet(url: url, options: options, type: .action, onError: completion) { (response) in
            // The response should be empty
            if response.rawValue != "" {
                response.error = MDError.actionFailed
            }
            completion(response)
        }
    }

    /// Mark a chapter as read
    /// - Parameter chapterId: The ID of the chapter
    /// - Parameter completion: The callback at the end of the request
    public func readChapter(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.readChapterAction(chapterId: chapterId)
        performAction(for: url, completion: completion)
    }

    /// Mark a chapter as unread
    /// - Parameter chapterId: The ID of the chapter
    /// - Parameter completion: The callback at the end of the request
    public func unreadChapter(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.unreadChapterAction(chapterId: chapterId)
        performAction(for: url, completion: completion)
    }

    /// Set a manga's reading status
    /// - Parameter chapterId: The ID of the manga
    /// - Parameter status: The new reading status
    /// - Parameter completion: The callback at the end of the request
    ///
    /// - Attention: Set a chapter's reading status to `MDReadingStatus.unfollow` will clear all the
    /// "read" marks
    public func setReadingStatus(mangaId: Int, status: MDReadingStatus, completion: @escaping MDCompletion) {
        // Build the URL depending on the status the user wants to set
        let url: URL
        switch status {
        case .unfollowed:
            url = MDPath.unfollowManga(mangaId: mangaId)
        default:
            url = MDPath.followManga(mangaId: mangaId, status: status)
        }

        // .all isn't a valid option
        guard status != .all else {
            let response = MDResponse(type: .action, url: url, rawValue: "", error: nil)
            response.error = MDError.actionFailed
            completion(response)
            return
        }

        performAction(for: url, completion: completion)
    }

}
