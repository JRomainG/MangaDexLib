//
//  MDParser+GroupInfo.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The selector to reach the element containing a group's name and cover image
    static private let groupHeaderSelector = "#content > .card"

    /// The selector to get the group's name from within the header
    static private let groupNameSelector = ".card-header > span.mx-1"

    /// The selector to get the group's cover image from within the header
    static private let groupImageSelector = "img.card-img-bottom"

    /// The selector to get the group's info containers
    static private let groupInfoContainerSelector = "#content > .row"

    /// Go through a `<div class="card">` element containing a `<table>` to
    /// extract its content to a list
    ///
    /// I don't like doing this, as it's a very fragile implementation, but here goes...
    private func parseCard(from element: Element) throws -> [(String, Element)] {
        let elements = try element.getElementsByTag("tr")
        var output: [(String, Element)] = []
        for element in elements {
            guard let key = try element.getElementsByTag("th").first(),
                let content = try element.getElementsByTag("td").first() else {
                    continue
            }
            output.append((try key.text(), content))
        }

        return output
    }

    /// Parse the link to a user's profile to get their name and ID
    ///
    /// The expected format is:
    /// `<a id="[id]" href="/user/[id]/[user-name]">[name]</a>`
    private func getUserFromLink(_ element: Element) throws -> MDUser? {
        guard let userId = Int(try element.attr("id")) else {
            return nil
        }
        let name = try element.text()
        return MDUser(name: name, userId: userId)
    }

    /// Extract a group's info in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: An `MDGroup` instance
    ///
    /// This implementation is particularly rather fragile, and is subject to breaking
    /// if the website changes the group page
    func getGroupInfo(from content: String) throws -> MDGroup? {
        let doc = try MDParser.parse(html: content)

        let infoContainer = try doc.select(MDParser.groupInfoContainerSelector).first()
        guard let infoCards = infoContainer?.children(),
            infoCards.count >= 2 else {
            return nil
        }

        // Should contain elements in the following order:
        // Group ID, Alt name, Stats, Links, Actions
        let groupInfo = try parseCard(from: infoCards.get(0))

        // Should contain elements in the following order:
        // Leader, Members, Upload restriction, Group delay
        let membersInfo = try parseCard(from: infoCards.get(1))

        // Basically praying for MangaDex not to change their layout,
        // though if they change it they may use ids or classes that we can find
        // and have a more robust implementation
        guard let groupIdString = groupInfo.first?.1,
            let groupId = Int(try groupIdString.text()) else {
                return nil
        }

        // Init a group that will be filled out little by little
        var group = MDGroup(groupId: groupId)

        // Get group's links
        if groupInfo.count >= 4 {
            let linkElements = try groupInfo[3].1.getElementsByClass("a")
            group.links = []
            for link in linkElements {
                group.links?.append(try link.attr("href"))
            }
        }

        // Get group's leader
        if let firstMembersElement = membersInfo.first?.1,
            let leaderElement = try firstMembersElement.getElementsByTag("a").first() {
            group.leader = try getUserFromLink(leaderElement)
        }

        // Get group's members
        if membersInfo.count >= 2 {
            let memberElements = try membersInfo[1].1.getElementsByTag("a")
            group.members = []
            for member in memberElements {
                if let user = try getUserFromLink(member) {
                    group.members?.append(user)
                }
            }
        }

        // Get other info about the group
        let header = try doc.select(MDParser.groupHeaderSelector).first()
        group.name = try header?.select(MDParser.groupNameSelector).first()?.text()
        group.coverUrl = try header?.select(MDParser.groupImageSelector).first()?.attr("src")
        return group
    }

}
