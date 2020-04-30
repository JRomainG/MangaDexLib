//
//  MDAnnouncement.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing an announcement returned by MangaDex
public struct MDAnnouncement {

    /// The content of the announcement
    ///
    /// The body may still contain HTML elements, like
    /// `<a>`, `<br>`, `<strong>`...
    /// Use `textBody` for the content stripped of its HTML elements
    public var body: String?

    /// The content of the announcement, stripped of its HTML elements
    public var textBody: String?

}
