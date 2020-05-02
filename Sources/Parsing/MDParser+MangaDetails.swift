//
//  MDParser+MangaDetails.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The suffix that MangaDex appends at the end of a manga's title
    static private let mangaInfoTitleSuffix = " (Title) - MangaDex"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's title
    static private let mangaInfoTitleSelector = "meta[property=og:title]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's description
    static private let mangaInfoDescriptionSelector = "meta[property=og:description]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's cover URL
    static private let mangaInfoImageSelector = "meta[property=og:image]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's link
    static private let mangaInfoHrefSelector = "link[rel=canonical]"

    /// The selector to lookup in the html page to find the connected user's reading status
    static private let mangaReadingStatusButtonSelector = "button[id=upload_button] + .btn-group"

    /// The class of the generic "Follow" button for a manga
    ///
    /// The format of the element is:
    /// `<button id="1" data-manga-id="[id]" type="button" class="manga_follow_button [...]"></button>`
    /// - Note: This element is only present if the user is logged in and hasen't set a reading status
    /// for the manga
    static private let mangaFollowButtonSelector = "button.manga_follow_button:not([disabled])"

    /// The class of the "Unfollow" link for a manga
    ///
    /// The format of the element is:
    /// `<a class="manga_unfollow_button" [...] >[...]</a>`
    /// - Note: This element is only present if the user is logged in and HAS set a reading status
    /// for the manga
    static private let mangaUnfollowLinkClass = "manga_unfollow_button"

    /// The class of all the "Follow" links for a manga
    ///
    /// The format of the element is:
    /// `<a class="manga_follow_button" id="[action-id]" [...] >[...]</a>`
    /// - Note: This element is only present if the user is logged in and HAS set a reading status
    /// for the manga
    static private let mangaFollowLinkClass = "manga_follow_button"

    /// A mapping between a `manga_follow_button`'s `id` attribute and
    /// the associated reading status
    static private let mangaFollowIdMapping: [String: MDReadingStatus] = [
        "1": .reading,
        "2": .completed,
        "3": .onHold,
        "4": .planToRead,
        "5": .dropped,
        "6": .reReading
    ]

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

    /// Attempt to guess the user's reading status for a manga based on the button
    ///
    /// For this, we fetch the list of links and see which one is disabled
    func getReadingStatus(from element: Element?) throws -> MDReadingStatus? {
        // If the manga has a defined reading status, there should be a list of options
        // Get which link is disabled in the list, which means it's the selected one
        if let selected = try element?.select("a.disabled").first() {
            // Check whether it's a follow or unfollow link
            let classNames = try selected.classNames()
            if classNames.contains(MDParser.mangaUnfollowLinkClass) {
                return .unfollowed
            } else if classNames.contains(MDParser.mangaFollowLinkClass) {
                let actionId = try selected.attr("id")
                return MDParser.mangaFollowIdMapping[actionId]
            }
        }

        // If the state is "unfollowed", there should be a button with the class mangaFollowButtonClass
        guard let button = try element?.select(MDParser.mangaFollowButtonSelector).first(),
            try button.attr("id") == "1" else {
            return nil
        }
        return .unfollowed
    }

    /// Extract a manga's info from a manga detail html page
    /// - Parameter content: The html string to parse
    /// - Returns: The extracted manga
    func getMangaDetails(from content: String) throws -> MDManga {
        let doc = try MDParser.parse(html: content)

        guard let head = doc.head() else {
            throw MDError.parseElementNotFound
        }

        let description = try getFirstAttribute("content", with: MDParser.mangaInfoDescriptionSelector, in: head)
        let coverUrl = try getFirstAttribute("content", with: MDParser.mangaInfoImageSelector, in: head)

        guard var title = try getFirstAttribute("content", with: MDParser.mangaInfoTitleSelector, in: head) else {
            throw MDError.parseElementNotFound
        }
        title = title.replacingOccurrences(of: MDParser.mangaInfoTitleSuffix, with: "")

        guard let href = try getFirstAttribute("href", with: MDParser.mangaInfoHrefSelector, in: head),
            let mangaId = getIdFromHref(href) else {
            throw MDError.parseElementNotFound
        }

        // Try to get the reading status, but don't throw if this fails
        // since the user might be logged out, and it's not a critical information
        let readingStatus: MDReadingStatus?
        do {
            let button = try doc.select(MDParser.mangaReadingStatusButtonSelector).first()
            readingStatus = try getReadingStatus(from: button)
        } catch {
            print(error)
            readingStatus = nil
        }

        var manga = MDManga(title: title, mangaId: mangaId)
        manga.description = description
        manga.coverUrl = coverUrl
        manga.readingStatus = readingStatus
        return manga
    }

}