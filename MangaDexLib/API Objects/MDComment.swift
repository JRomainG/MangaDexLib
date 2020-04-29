//
//  MDComment.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a comment returned by MangaDex
struct MDComment {

    /// The id of the chapter
    var commentId: Int

    /// The id of the thread this comment belongs to
    var threadId: Int

    /// The content of the comment
    ///
    /// The body may still contain HTML elements, like
    /// `<a>`, `<br>`, `<button>`, `<img>`...
    var body: String?

    /// The content of the comment, stripped of its HTML elements
    var textBody: String?

    /// The user who posted the comment
    var user: MDUser?

    /// A boolean indicating whether the comment was deleted
    var deleted = false

}