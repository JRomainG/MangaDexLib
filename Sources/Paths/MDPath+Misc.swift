//
//  MDPath+Misc.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a MD@Home node URL
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func getAtHomeNodeURL(chapterId: String) -> URL {
        return buildUrl(for: .atHome, with: ["server", chapterId])
    }

    /// Build the URL to transform legacy object IDs to v5 object IDs
    /// - Returns: The MangaDex URL
    public static func getLegacyMapping() -> URL {
        return buildUrl(for: .legacy, with: ["mapping"])
    }

    /// Build the URL to perform a ping request
    /// - Returns: The MangaDex URL
    public static func ping() -> URL {
        return buildUrl(for: .ping)
    }

}
