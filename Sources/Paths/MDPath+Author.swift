//
//  MDPath+Author.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of authors
    /// - Returns: The MangaDex URL
    public static func getAuthorList() -> URL {
        return buildUrl(for: .author)
    }

    /// Build the URL to create a new author
    /// - Returns: The MangaDex URL
    public static func createAuthor() -> URL {
        return buildUrl(for: .author)
    }

    /// Build the URL to view the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Returns: The MangaDex URL
    public static func viewAuthor(authorId: String) -> URL {
        return buildUrl(for: .author, with: [authorId])
    }

    /// Build the URL to update the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Returns: The MangaDex URL
    public static func updateAuthor(authorId: String) -> URL {
        return buildUrl(for: .author, with: [authorId])
    }

    /// Build the URL to delete the specified author
    /// - Parameter authorId: The id of the author
    /// - Returns: The MangaDex URL
    public static func deleteAuthor(authorId: String) -> URL {
        return buildUrl(for: .author, with: [authorId])
    }

}
