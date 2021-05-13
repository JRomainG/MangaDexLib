//
//  MDApi+Group.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 12/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of scanlation groups
    /// - Parameter completion: The completion block called once the request is done
    public func getGroupList(completion: @escaping (MDResultList<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.getGroupList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Search the list of scanlation groups using the specified filter
    /// - Parameter filter: The filter to use
    /// - Parameter completion: The completion block called once the request is done
    public func searchGroups(filter: MDGroupFilter,
                             completion: @escaping (MDResultList<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.searchGroups(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Create a scanlation group with the specified information
    /// - Parameter info: The scanlation group information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createGroup(info: MDGroup, completion: @escaping (MDGroup?, MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// View the specified scanlation group's information
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    public func viewGroup(groupId: String, completion: @escaping (MDResult<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.viewGroup(groupId: groupId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified scanlation group's information
    /// - Parameter info: The scanlation group information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateGroup(info: MDGroup, completion: @escaping (MDGroup?, MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Delete the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Follow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func followGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

    /// Unfollow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func unfollowGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        // TODO: API is currently readonly
    }

}
