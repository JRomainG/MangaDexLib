//
//  MDPath+Action.swift
//  MangaDexLib-iOS
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL used to log in
    /// - Parameter javascriptEnabled: Whether javascript should be marked as disabled or not
    /// - Returns: The ajax URL
    public static func loginAction(javascriptEnabled: Bool = true) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.login.rawValue),
            URLQueryItem(name: AjaxParam.noJS.rawValue, value: javascriptEnabled ? nil : "1")
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to log out
    /// - Parameter javascriptEnabled: Whether javascript should be marked as disabled or not
    /// - Returns: The ajax URL
    public static func logoutAction(javascriptEnabled: Bool = true) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.logout.rawValue),
            URLQueryItem(name: AjaxParam.noJS.rawValue, value: javascriptEnabled ? nil : "1")
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to mark a chapter as read
    /// - Parameter chapterId: The identifier of the chapter
    /// - Returns: The ajax URL
    public static func readChapterAction(chapterId: Int) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.readChapter.rawValue),
            URLQueryItem(name: AjaxParam.objectId.rawValue, value: String(chapterId))
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to mark a chapter as unread
    /// - Parameter chapterId: The identifier of the chapter
    /// - Returns: The ajax URL
    public static func unreadChapterAction(chapterId: Int) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.unreadChapter.rawValue),
            URLQueryItem(name: AjaxParam.objectId.rawValue, value: String(chapterId))
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to change a chapter's reading status
    /// - Parameter mangaId: The identifier of the chapter
    /// - Parameter status: The reading status to set
    /// - Returns: The ajax URL
    public static func followManga(mangaId: Int, status: MDReadingStatus) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.followManga.rawValue),
            URLQueryItem(name: AjaxParam.objectId.rawValue, value: String(mangaId)),
            URLQueryItem(name: AjaxParam.type.rawValue, value: String(status.rawValue))
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to unfollow a manga
    /// - Parameter mangaId: The identifier of the chapter
    /// - Returns: The ajax URL
    public static func unfollowManga(mangaId: Int) -> URL {
        // When unfollowing a manga, the type value isn't useful, but it has to be set
        // The website just used the manga's ID, so let's do the same
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.unfollowManga.rawValue),
            URLQueryItem(name: AjaxParam.objectId.rawValue, value: String(mangaId)),
            URLQueryItem(name: AjaxParam.type.rawValue, value: String(mangaId))
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to post a comment
    /// - Parameter threadId: The identifier of the thread
    /// - Returns: The ajax URL
    public static func comment(threadId: Int) -> URL {
        let params = [
            URLQueryItem(name: AjaxParam.function.rawValue, value: AjaxFunction.comment.rawValue),
            URLQueryItem(name: AjaxParam.objectId.rawValue, value: String(threadId))
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

}
