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
    /// - Parameter filter: The filter to apply
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func getAuthorList(filter: MDAuthorFilter? = nil, includes: [MDObjectType]? = nil) -> URL {
        var params = filter?.getParameters() ?? []
        params += MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .author, params: params)
    }

    /// Build the URL to create a new author
    /// - Returns: The MangaDex URL
    static func createAuthor() -> URL {
        return buildUrl(for: .author)
    }

    /// Build the URL to view the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func viewAuthor(authorId: String, includes: [MDObjectType]? = nil) -> URL {
        let params = MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .author, with: [authorId], params: params)
    }

    /// Build the URL to update the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Returns: The MangaDex URL
    static func updateAuthor(authorId: String) -> URL {
        return buildUrl(for: .author, with: [authorId])
    }

    /// Build the URL to delete the specified author
    /// - Parameter authorId: The id of the author
    /// - Returns: The MangaDex URL
    static func deleteAuthor(authorId: String) -> URL {
        return buildUrl(for: .author, with: [authorId])
    }

}
