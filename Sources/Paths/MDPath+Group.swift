//
//  MDPath+Group.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of scanlation groups
    /// - Returns: The MangaDex URL
    public static func getGroupList() -> URL {
        return buildUrl(for: .group)
    }

    /// Build the URL to create a new scanlation group
    /// - Returns: The MangaDex URL
    public static func createGroup() -> URL {
        return buildUrl(for: .group)
    }

    /// Build the URL to view the specified scanlation group's information
    /// - Parameter groupId: The id of the scanlation group
    /// - Returns: The MangaDex URL
    public static func viewGroup(groupId: String) -> URL {
        return buildUrl(for: .group, with: [groupId])
    }

    /// Build the URL to update the specified scanlation group's information
    /// - Parameter groupId: The id of the scanlation group
    /// - Returns: The MangaDex URL
    public static func updateGroup(groupId: String) -> URL {
        return buildUrl(for: .group, with: [groupId])
    }

    /// Build the URL to delete the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Returns: The MangaDex URL
    public static func deleteGroup(groupId: String) -> URL {
        return buildUrl(for: .group, with: [groupId])
    }

    /// Build the URL to follow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Returns: The MangaDex URL
    public static func followGroup(groupId: String) -> URL {
        return buildUrl(for: .group, with: [groupId, "follow"])
    }

    /// Build the URL to unfollow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Returns: The MangaDex URL
    public static func unfollowGroup(groupId: String) -> URL {
        return buildUrl(for: .group, with: [groupId, "follow"])
    }

}
