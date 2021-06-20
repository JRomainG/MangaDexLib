//
//  MDPath+User.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of users
    /// - Parameter filter: The filter to apply
    /// - Returns: The MangaDex URL
    static func getUserList(filter: MDUserFilter? = nil) -> URL {
        let params = filter?.getParameters() ?? []
        return buildUrl(for: .user, params: params)
    }

    /// Build the URL to view the specified user's information
    /// - Parameter userId: The id of the user
    /// - Returns: The MangaDex URL
    static func viewUser(userId: String) -> URL {
        return buildUrl(for: .user, with: [userId])
    }

    /// Build the URL to view the logged-in user's information
    /// - Returns: The MangaDex URL
    static func viewLoggedUser() -> URL {
        return buildUrl(for: .user, with: ["me"])
    }

    /// Build the URL to get the logged-in user's list of followed manga
    /// - Parameter pagination: The pagination filter to apply
    /// - Returns: The MangaDex URL
    static func getLoggedUserFollowedMangaList(pagination: MDPaginationFilter? = nil) -> URL {
        let params = pagination?.getParameters() ?? []
        return buildUrl(for: .user, with: ["follows", Endpoint.manga.rawValue], params: params)
    }

    /// Build the URL to get the logged-in user's feed of followed manga
    /// - Parameter filter: The filter to apply
    /// - Returns: The MangaDex URL
    static func getLoggedUserFollowedMangaFeed(filter: MDFeedFilter? = nil) -> URL {
        let params = filter?.getParameters() ?? []
        return buildUrl(for: .user, with: ["follows", Endpoint.manga.rawValue, "feed"], params: params)
    }

    /// Build the URL to get the logged-in user's list of followed scanlation groups
    /// - Parameter pagination: The pagination filter to apply
    /// - Returns: The MangaDex URL
    static func getLoggedUserFollowedGroupList(pagination: MDPaginationFilter? = nil) -> URL {
        let params = pagination?.getParameters() ?? []
        return buildUrl(for: .user, with: ["follows", Endpoint.group.rawValue], params: params)
    }

    /// Build the URL to get the logged-in user's list of followed users
    /// - Parameter pagination: The pagination filter to apply
    /// - Returns: The MangaDex URL
    static func getLoggedUserFollowedUserList(pagination: MDPaginationFilter? = nil) -> URL {
        let params = pagination?.getParameters() ?? []
        return buildUrl(for: .user, with: ["follows", Endpoint.user.rawValue], params: params)
    }

    /// Build the URL to get the logged-in user's list of custom lists
    /// - Parameter pagination: The pagination filter to apply
    /// - Returns: The MangaDex URL
    static func getLoggedUserCustomLists(pagination: MDPaginationFilter? = nil) -> URL {
        let params = pagination?.getParameters() ?? []
        return buildUrl(for: .user, with: [Endpoint.customList.rawValue], params: params)
    }

    /// Build the URL to get the specified user's list of custom lists
    /// - Parameter userId: The id of the user
    /// - Parameter pagination: The pagination filter to apply
    /// - Returns: The MangaDex URL
    /// - Note: This will only list public custom lists
    static func getUserCustomLists(userId: String, pagination: MDPaginationFilter? = nil) -> URL {
        let params = pagination?.getParameters() ?? []
        return buildUrl(for: .user, with: [Endpoint.customList.rawValue], params: params)
    }

}
