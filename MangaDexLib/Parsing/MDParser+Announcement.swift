//
//  MDParser+Announcement.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The id of the announcement element MangaDex's pages
    ///
    /// The format of the element is:
    /// `<div id="announcement" class="alert [...]" role="alert">[content]</div>`
    static private let announcementId = "announcement"

    /// The selector to lookup in a MangaDex page to get the alerts
    ///
    /// The format of each element is:
    /// `<div class="alert [...]" role="alert">[content]</div>`
    static private let alertSelector = "div.alert[role=alert]:not(#announcement)"

    /// Extract the announcement at the top of the page
    /// - Parameter content: The html string to parse
    /// - Returns: An `MDAnnouncement` instance, or nil
    func getAnnouncement(from content: String) -> MDAnnouncement? {
        do {
            let doc = try MDParser.parse(html: content)
            guard let element = try doc.getElementById(MDParser.announcementId) else {
                return nil
            }
            return MDAnnouncement(body: try element.html(), textBody: try element.text())
        } catch {
            return nil
        }
    }

    /// Extract the alerts (but not the announcement) at the top of the page
    /// - Parameter content: The html string to parse
    /// - Returns: A list of `MDAnnouncement` instances
    func getAlerts(from content: String) -> [MDAnnouncement] {
        var alerts: [MDAnnouncement] = []
        do {
            let doc = try MDParser.parse(html: content)
            let elements = try doc.select(MDParser.alertSelector)

            for element in elements {
                let alert = MDAnnouncement(body: try element.html(), textBody: try element.text())
                alerts.append(alert)
            }
        } catch {
        }

        return alerts
    }

}
