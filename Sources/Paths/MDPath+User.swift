//
//  MDPath+User.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get the specified user's information
    /// - Parameter userId: The id of the user
    /// - Returns: The MangaDex URL
    public static func getUser(userId: String) -> URL {
        return buildUrl(for: .user, with: [userId])
    }

    /// Build the URL to get the logged-in user's information
    /// - Returns: The MangaDex URL
    public static func getLoggedUser() -> URL {
        return buildUrl(for: .user, with: ["me"])
    }

    /// Build the URL to get the logged-in user's list of followed manga
    /// - Returns: The MangaDex URL
    public static func getLoggedUserFollowedMangaList() -> URL {
        return buildUrl(for: .user, with: ["follows", Endpoint.manga.rawValue])
    }

    /// Build the URL to get the logged-in user's feed of followed manga
    /// - Returns: The MangaDex URL
    public static func getLoggedUserFollowedMangaFeed() -> URL {
        return buildUrl(for: .user, with: ["follows", Endpoint.manga.rawValue, "feed"])
    }

    /// Build the URL to get the logged-in user's list of followed scanlation groups
    /// - Returns: The MangaDex URL
    public static func geLoggedtUserFollowedGroupList() -> URL {
        return buildUrl(for: .user, with: ["follows", Endpoint.group.rawValue])
    }

    /// Build the URL to get the logged-in user's list of followed users
    /// - Returns: The MangaDex URL
    public static func geLoggedtUserFollowedUserList() -> URL {
        return buildUrl(for: .user, with: ["follows", Endpoint.user.rawValue])
    }

    /// Build the URL to get the logged-in user's list of custom lists
    /// - Returns: The MangaDex URL
    public static func getLoggedUserCustomLists() -> URL {
        return buildUrl(for: .user, with: [Endpoint.customList.rawValue])
    }

    /// Build the URL to get the specified user's list of custom lists
    /// - Parameter userId: The id of the user
    /// - Returns: The MangaDex URL
    /// - Note: This will only list public custom lists
    public static func getUserCustomLists(userId: String) -> URL {
        return buildUrl(for: .user, with: [Endpoint.customList.rawValue])
    }

}
