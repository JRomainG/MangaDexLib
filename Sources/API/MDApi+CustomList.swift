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
    public func createCustomList(info: MDCustomList, completion: @escaping (MDCustomList?, MDApiError?) -> Void) {
        // TODO: API is currently readonly
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
    /// - Parameter info: The custom list information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateCustomList(info: MDCustomList, completion: @escaping (MDCustomList?, MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Delete the specified custom list
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteCustomList(listId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Get the specified custom list's feed (aka its list of chapters)
    /// - Parameter listId: The id of the custom list
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getCustomListFeed(listId: String,
                                  completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getCustomListFeed(listId: listId)
        performBasicGetCompletion(url: url, completion: completion)
    }

}
