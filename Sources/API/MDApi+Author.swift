//
//  MDApi+Author.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of authors
    /// - Parameter filter: The filter to use
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func getAuthorList(filter: MDAuthorFilter? = nil,
                              includes: [MDObjectType]? = nil,
                              completion: @escaping (MDResultList<MDAuthor>?, MDApiError?) -> Void) {
        let url = MDPath.getAuthorList(filter: filter, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Create an author with the specified information
    /// - Parameter info: The author information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createAuthor(info: MDAuthor, completion: @escaping (MDResult<MDAuthor>?, MDApiError?) -> Void) {
        let url = MDPath.createAuthor()
        performBasicPostCompletion(url: url, data: info, completion: completion)
    }

    /// View the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func viewAuthor(authorId: String,
                           includes: [MDObjectType]? = nil,
                           completion: @escaping (MDResult<MDAuthor>?, MDApiError?) -> Void) {
        let url = MDPath.viewAuthor(authorId: authorId, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified author's information
    /// - Parameter authorId: The id of the author
    /// - Parameter info: The author information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateAuthor(authorId: String, info: MDAuthor,
                             completion: @escaping (MDResult<MDAuthor>?, MDApiError?) -> Void) {
        let url = MDPath.updateAuthor(authorId: authorId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }

    /// Delete the specified author
    /// - Parameter authorId: The id of the author
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteAuthor(authorId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteAuthor(authorId: authorId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

}
