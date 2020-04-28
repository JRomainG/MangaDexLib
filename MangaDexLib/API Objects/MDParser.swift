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

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's meta information
    static let mangaInfoMetaTag = "head"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's title
    static let mangaInfoTitleSelector = "meta[property=og:title]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's description
    static let mangaInfoDescriptionSelector = "meta[property=og:description]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's cover URL
    static let mangaInfoImageSelector = "meta[property=og:image]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's link
    static let mangaInfoHrefSelector = "link[rel=canonical]"

    /// Convenience method to get an attribute out an `Element`
    /// - Parameter attribute: The attribute to extract
    /// - Parameter selector: The selector to use
    /// - Parameter element: The element in which to lookup
    /// - Returns: The attribute's value
    func getFirstAttribute(_ attribute: String,
                           with selector: String,
                           in element: Element) throws -> String? {
        let elements = try element.select(selector)
        guard let first = elements.first() else {
            return nil
        }
        return try first.attr(attribute)
    }

    /// Extract a manga's info from a manga detail html page
    /// - Parameter content: The html string to parse
    /// - Returns: The extracted manga
    func getMangaInfo(from content: String) throws -> MDManga? {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByTag(MDParser.mangaInfoMetaTag)

        guard let head = elements.first() else {
            return nil
        }

        let description = try getFirstAttribute("content", with: MDParser.mangaInfoDescriptionSelector, in: head)
        let coverUrl = try getFirstAttribute("content", with: MDParser.mangaInfoImageSelector, in: head)

        guard let title = try getFirstAttribute("content", with: MDParser.mangaInfoTitleSelector, in: head) else {
            return nil
        }

        guard let href = try getFirstAttribute("href", with: MDParser.mangaInfoHrefSelector, in: head),
            let mangaId = getIdFromHref(href) else {
            return nil
        }

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

// MARK: - MDParser Login

extension MDParser {

    /// The id of the login form in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<form method="post" id="login_form" action="[...]">`
    static let loginFormId = "login_form"

    /// The id of the username input field  in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<input name="login_username" id="login_username">`
    static let loginUsernameInputId = "login_username"

    /// The id of the username input field  in MangaDex's login page
    ///
    /// The format of the element is:
    /// `<input name="login_password" id="login_password">`
    static let loginPasswordInputId = "login_password"

    /// Find out if the given user was redirected to the login page
    /// - Parameter doc: The document the analyze
    /// - Returns: A boolean indicating whether this is the login page
    func isLoginPage(document: Document) -> Bool {
        do {
            let loginForm = try document.getElementById(MDParser.loginFormId)
            guard try loginForm?.getElementById(MDParser.loginUsernameInputId) != nil else {
                return false
            }
            guard try loginForm?.getElementById(MDParser.loginPasswordInputId) != nil else {
                return false
            }
        } catch {
            return false
        }

        return true
    }

}
