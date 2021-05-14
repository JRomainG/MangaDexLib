//
//  MDApi+CustomList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Create a custom list with the specified information
    /// - Parameter info: The list information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createCustomList(info: MDCustomList,
                                 completion: @escaping (MDResult<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.createCustomList()
        performBasicPostCompletion(url: url, data: info, completion: completion)
    }

    /// View the specified custom list's information
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func viewCustomList(listId: String, completion: @escaping (MDResult<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.viewCustomList(listId: listId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified custom list's information
    /// - Parameter listId: The id of the custom list
    /// - Parameter info: The custom list information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateCustomList(listId: String,
                                 info: MDCustomList,
                                 completion: @escaping (MDResult<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.updateCustomList(listId: listId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }

    /// Delete the specified custom list
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteCustomList(listId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteCustomList(listId: listId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

    /// Get the specified custom list's feed (aka its list of chapters)
    /// - Parameter listId: The id of the custom list
    /// - Parameter filter: The filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getCustomListFeed(listId: String,
                                  filter: MDFeedFilter? = nil,
                                  completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getCustomListFeed(listId: listId, filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

}
