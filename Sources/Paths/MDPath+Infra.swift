//
//  MDPath+Infra.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a MD@Home node URL
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter forcePort443: Force selecting from MangaDex@Home servers that use the standard HTTPS port 443.
    ///   This might be useful for networks with aggressive firewalls (e.g. school/office networks)
    /// - Returns: The MangaDex URL
    ///
    /// This is used to get the URL of the server which will server a chapter's images
    static func getAtHomeNodeURL(chapterId: String, forcePort443: Bool = false) -> URL {
        let encodedValue: String = forcePort443 ? "true" : "false"
        let params = [URLQueryItem(name: "forcePort443", value: encodedValue)]
        return buildUrl(for: .atHome, with: ["server", chapterId], params: params)
    }

    /// Build the URL to report fetching an image using the MD@Home netword
    /// - Returns: The MangaDex URL
    static func sendAtHomeReport() -> URL {
        let url = URL(string: MDApi.networkBaseURL)
        return url!.appendingPathComponent(Endpoint.report.rawValue)
    }

    /// Build the URL to get a list of reasons for which the given type of object can be reported
    /// - Parameter objectType: The type of object for which to return existing report reasons
    /// - Returns: The MangaDex URL
    static func getReportReasons(objectType: MDObjectType) -> URL {
        return buildUrl(for: .report, with: ["reasons", objectType.rawValue])
    }

    /// Build the URL to report an entry hosted on the MangaDex website
    /// - Returns: The MangaDex URL
    static func createReport() -> URL {
        return buildUrl(for: .report)
    }

    /// Build the URL to transform legacy object IDs to v5 object IDs
    /// - Returns: The MangaDex URL
    static func getLegacyMapping() -> URL {
        return buildUrl(for: .legacy, with: ["mapping"])
    }

    /// Build the URL to perform a ping request
    /// - Returns: The MangaDex URL
    static func ping() -> URL {
        return buildUrl(for: .ping)
    }

    /// Build the URL to solve a captcha challenge
    /// - Returns: The MangaDex URL
    static func solveCaptcha() -> URL {
        return buildUrl(for: .captcha, with: ["solve"])
    }

}
