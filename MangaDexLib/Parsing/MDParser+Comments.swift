//
//  MDParser+Comments.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The selector matching the link to lookup in the extracted html of MangaDex
    /// comment or thread pages to get the thread id
    ///
    /// The format of the element is (`[page]` may be absent):
    /// `<a href="/thread/[id]/[page]">[...]</a>`
    static private let threadHrefSelector = "a[href*=/thread/]"

    /// The name of the class to lookup in the extracted html of MangaDex comment feeds
    /// to get a comment's data
    ///
    /// The format of the element is:
    /// `<tr class="post" id="post_[id]">`
    static private let commentEntryClass = "post"

    /// The prefix to remove from a comment's div.id to get the numerical id
    static private let commentIdPrefix = "post_"

    /// The name of the class to lookup in the extracted html of MangaDex comment feeds
    /// to get a comment's data
    ///
    /// The format of the element is:
    /// `<div class="postbody [...]">[comment]</div>`
    static private let commentBodyClass = "postbody"

    /// The selector matching the classes to lookup in the extracted html of MangaDex
    /// comment feeds to get a user's name and ID
    ///
    /// The format of the element is:
    /// `<a class="user_level_[role]" " href="/user/[id]/[login]">[name]</a>`
    static private let userClassSelector = "[class^=user_level_]"

    /// The prefix to remove from a user's class to get their role
    static private let userRoleClassPrefix = "user_level_"

    /// The regex matching the classes to lookup in the extracted html of MangaDex
    /// comment feeds to get a user's name and ID
    ///
    /// The format of the element is:
    /// `<img class="avatar [...]" src="https://mangadex.org/images/avatars/[user-id].gif?[avatar-id]">`
    static private let userAvatarClass = "avatar"

    /// Extract the thread ID from the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: The thread's ID
    private func getThreadId(from document: Document) throws -> Int? {
        let elements = try document.select(MDParser.threadHrefSelector)
        guard let href = try elements.first()?.attr("href") else {
            return nil
        }
        return getIdFromHref(href)
    }

    /// Extract the user info from the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: An `MDUser` instance
    private func getUser(from element: Element) throws -> MDUser? {
        // Extract the avatar
        var elements = try element.getElementsByClass(MDParser.userAvatarClass)

        guard let image = elements.first() else {
            return nil
        }
        let avatar = try image.attr("src")

        // Extract all the other info
        elements = try element.select(MDParser.userClassSelector)
        guard let title = elements.first() else {
            return nil
        }

        let href = try title.attr("href")
        let rankClass = try title.attr("class")

        let userId = getIdFromHref(href)
        let name = try title.text()
        let rankName = rankClass.dropFirst(MDParser.userRoleClassPrefix.count)
        let rank = MDRank.init(rawValue: String(rankName))

        // Make sure the user has a user id
        guard userId != nil else {
            return nil
        }

        var user = MDUser(name: name, userId: userId!)
        user.rank = rank
        user.avatar = avatar
        return user
    }

    /// Extract the list of comments present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of comments
    func getComments(from content: String) throws -> [MDComment] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.commentEntryClass)

        var comments: [MDComment] = []

        // Make sure the thread has a valid ID
        guard let threadId = try getThreadId(from: doc) else {
            return comments
        }

        for element in elements {
            // Make sure the comment has a valid ID
            let commentIdString = element.id().dropFirst(MDParser.commentIdPrefix.count)
            guard let commentId = Int(commentIdString) else {
                continue
            }

            // Extract the user for this element
            guard let user = try getUser(from: element) else {
                var comment = MDComment(commentId: commentId, threadId: threadId)
                comment.deleted = true
                comments.append(comment)
                continue
            }

            let body = try element.getElementsByClass(MDParser.commentBodyClass).first()
            let comment = MDComment(commentId: commentId,
                                    threadId: threadId,
                                    body: try body?.html(),
                                    textBody: try body?.text(),
                                    user: user)
            comments.append(comment)
        }
        return comments
    }

}
