//
//  MDParser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

/// The class responsible for parsing HTML / JSON to Swift objects
class MDParser {

    static func parse(html: String) throws -> Document {
        return try SwiftSoup.parse(html)
    }

    static func parse<T>(json: String, type: T.Type) throws -> T where T: Decodable {
        let jsonData = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: jsonData)
    }

}

// MARK: - MDParser Common Manga Methods

extension MDParser {

    /// Split an absolute of relative URL's path in a normalized way
    private func splitUrlPath(_ href: String) -> [String] {
        // If this is an absolute URL, only keep the path
        var path = href

        if let url = URL(string: href) {
            path = url.path
        }

        // Remove the leading "/" if there is one
        if path.hasPrefix("/") {
            path.remove(at: path.startIndex)
        }

        return path.components(separatedBy: "/")
    }

    /// Extract the id from the link to a manga or user
    ///
    /// The format is `/title/[id]/[manga-name]`, absolute and relative URLs are handled
    private func getIdFromHref(_ href: String) -> Int? {
        let components = splitUrlPath(href)
        guard components.count >= 2 else {
            return nil
        }
        return Int(components[1])
    }

}

// MARK: - MDParser Homepage Manga List

extension MDParser {

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's ID
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryClass = "manga-entry"

    /// The name of the parameter to lookup in an extracted manga entry to get
    /// the manga's ID
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryIdKey = "data-id"

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get the manga's title and ID
    ///
    /// The format of the element is:
    /// `<a title="[...]" href="/title/[id]/[...]" class="manga_title [...]">[...]</a>`
    static let mangaEntryTitleClass = "manga_title"

    /// Extract the list of mangas present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of mangas IDs
    ///
    /// Only the `title` and `id` are extracted by this method
    func getMangas(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.mangaEntryTitleClass)

        var mangas: [MDManga] = []
        for element in elements {
            // Extract the info for this element
            let title = try element.text()
            let href = try element.attr("href")

            // To be more robust, ignore mangas for which the extract failed
            // Indeed, sometimes other elements have the same class as what we're looking for
            if let mangaId = self.getIdFromHref(href) {
                mangas.append(MDManga(title: title, mangaId: mangaId))
            }
        }
        return mangas
    }

    /// Extract the list of manga IDs present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of mangas IDs
    ///
    /// This can be used as backup if `getMangas` fails
    func getMangaIds(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.mangaEntryClass)

        var mangas: [MDManga] = []
        for element in elements {
            let mangaIdString = try element.attr(MDParser.mangaEntryIdKey)

            if let mangaId = Int(mangaIdString) {
                mangas.append(MDManga(mangaId: mangaId))
            }
        }
        return mangas
    }

}

// MARK: - MDParser Manga Page

extension MDParser {

    /// Extract a manga's info from a manga detail html page
    /// - Parameter content: The html string to parse
    /// - Returns: The extracted manga
    func getMangaInfo(from content: String) throws -> MDManga {
        let doc = try MDParser.parse(html: content)

        // Extra the meta tags, as it's way easier
        var elements = try doc.select("head > meta[property=og:title]")
        let title = try elements.get(0).attr("content").replacingOccurrences(of: " (Title) - MangaDex", with: "")

        elements = try doc.select("head > meta[property=og:description]")
        let description = try elements.get(0).attr("content")

        elements = try doc.select("head > meta[property=og:image]")
        let coverUrl = try elements.get(0).attr("content")

        elements = try doc.select("head > link[rel=canonical]")
        let href = try elements.get(0).attr("href")
        let mangaId = getIdFromHref(href)!

        var manga = MDManga(title: title, mangaId: mangaId)
        manga.description = description
        manga.coverUrl = coverUrl
        return manga
    }

}

// MARK: - MDParser Comments

extension MDParser {

    /// The selector matching the link to lookup in the extracted html of MangaDex
    /// comment or thread pages to get the thread id
    ///
    /// The format of the element is (`[page]` may be absent):
    /// `<a href="/thread/[id]/[page]">[...]</a>`
    static let threadHrefSelector = "a[href*=/thread/]"

    /// The name of the class to lookup in the extracted html of MangaDex comment feeds
    /// to get a comment's data
    ///
    /// The format of the element is:
    /// `<tr class="post" id="post_[id]">`
    static let commentEntryClass = "post"

    /// The prefix to remove from a comment's div.id to get the numerical id
    static let commentIdPrefix = "post_"

    /// The name of the class to lookup in the extracted html of MangaDex comment feeds
    /// to get a comment's data
    ///
    /// The format of the element is:
    /// `<div class="postbody [...]">[comment]</div>`
    static let commentBodyClass = "postbody"

    /// The selector matching the classes to lookup in the extracted html of MangaDex
    /// comment feeds to get a user's name and ID
    ///
    /// The format of the element is:
    /// `<a class="user_level_[role]" " href="/user/[id]/[login]">[name]</a>`
    static let userClassSelector = "[class^=user_level_]"

    /// The prefix to remove from a user's class to get their role
    static let userRoleClassPrefix = "user_level_"

    /// The regex matching the classes to lookup in the extracted html of MangaDex
    /// comment feeds to get a user's name and ID
    ///
    /// The format of the element is:
    /// `<img class="avatar [...]" src="https://mangadex.org/images/avatars/[user-id].gif?[avatar-id]">`
    static let userAvatarClass = "avatar"

    /// Extract the thread ID from the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: The thread's ID
    private func getThreadId(from document: Document) throws -> Int? {
        let elements = try document.select(MDParser.threadHrefSelector)
        let href = try elements.get(0).attr("href")
        return getIdFromHref(href)
    }

    /// Extract the user info from the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: An `MDUser` instance
    private func getUser(from element: Element) throws -> MDUser? {
        // Extract the avatar
        let image = try element.getElementsByClass(MDParser.userAvatarClass)

        guard image.count > 0 else {
            return nil
        }
        let avatar = try image.get(0).attr("src")

        // Extract all the other info
        let title = try element.select(MDParser.userClassSelector)

        guard image.count > 0 else {
            return nil
        }

        let href = try title.get(0).attr("href")
        let rankClass = try title.get(0).attr("class")

        let userId = getIdFromHref(href)
        let name = try title.get(0).text()
        let rank = rankClass.dropFirst(MDParser.userRoleClassPrefix.count)

        // Make sure the user has a user id
        guard userId != nil else {
            return nil
        }

        return MDUser(userId: userId!, name: name, rank: String(rank), avatar: avatar)
    }

    /// Extract the list of comments present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of comments
    ///
    /// Only the `title` and `id` are extracted by this method
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

            let body = try element.getElementsByClass(MDParser.commentBodyClass).get(0)
            let comment = MDComment(commentId: commentId,
                                    threadId: threadId,
                                    body: try body.html(),
                                    textBody: try body.text(),
                                    user: user)
            comments.append(comment)
        }
        return comments
    }

}
