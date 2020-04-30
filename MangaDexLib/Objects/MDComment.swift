//
//  MDComment.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a comment returned by MangaDex
public struct MDComment {

    /// The id of the chapter
    public var commentId: Int

    /// The id of the thread this comment belongs to
    public var threadId: Int

    /// The content of the comment
    ///
    /// The body may still contain HTML elements, like
    /// `<a>`, `<br>`, `<button>`, `<img>`...
    /// Use `textBody` for the content stripped of its HTML elements
    public var body: String?

    /// The content of the comment, stripped of its HTML elements
    public var textBody: String?

    /// The user who posted the comment
    public var user: MDUser?

    /// A boolean indicating whether the comment was deleted
    public var deleted = false

}
