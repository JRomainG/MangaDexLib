//
//  MDPath+CustomList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to create a new custom lists
    /// - Returns: The MangaDex URL
    static func createCustomList() -> URL {
        return buildUrl(for: .customList)
    }

    /// Build the URL to view the specified custom list's information
    /// - Parameter listId: The id of the custom list
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Returns: The MangaDex URL
    static func viewCustomList(listId: String, includes: [MDObjectType]? = nil) -> URL {
        let params = MDPath.formatQueryItem(name: "includes", array: includes)
        return buildUrl(for: .customList, with: [listId], params: params)
    }

    /// Build the URL to update the specified custom list's information
    /// - Parameter listId: The id of the custom list
    /// - Returns: The MangaDex URL
    static func updateCustomList(listId: String) -> URL {
        return buildUrl(for: .customList, with: [listId])
    }

    /// Build the URL to delete the specified custom list
    /// - Parameter listId: The id of the custom list
    /// - Returns: The MangaDex URL
    static func deleteCustomList(listId: String) -> URL {
        return buildUrl(for: .customList, with: [listId])
    }

    /// Build the URL to get the specified custom list's feed
    /// - Parameter listId: The id of the custom list
    /// - Parameter filter: The filter to apply
    /// - Returns: The MangaDex URL
    static func getCustomListFeed(listId: String, filter: MDFeedFilter? = nil) -> URL {
        let params = filter?.getParameters() ?? []
        return buildUrl(for: .customList, with: [listId, "feed"], params: params)
    }

}
