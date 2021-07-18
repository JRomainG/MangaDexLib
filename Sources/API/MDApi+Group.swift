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
    /// - Parameter filter: The filter to use
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func getGroupList(filter: MDGroupFilter? = nil,
                             includes: [MDObjectType]? = nil,
                             completion: @escaping (MDResultList<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.getGroupList(filter: filter, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Create a scanlation group with the specified information
    /// - Parameter info: The scanlation group information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func createGroup(info: MDGroup, completion: @escaping (MDResult<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.createGroup()
        performBasicPostCompletion(url: url, data: info, completion: completion)
    }

    /// View the specified scanlation group's information
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func viewGroup(groupId: String,
                          includes: [MDObjectType]? = nil,
                          completion: @escaping (MDResult<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.viewGroup(groupId: groupId, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified scanlation group's information
    /// - Parameter groupId: The scanlation group's id
    /// - Parameter info: The scanlation group information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateGroup(groupId: String,
                            info: MDGroup,
                            completion: @escaping (MDResult<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.updateGroup(groupId: groupId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }

    /// Delete the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteGroup(groupId: groupId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

    /// Follow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func followGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.followGroup(groupId: groupId)
        performPost(url: url, body: "") { (response) in
            completion(response.error)
        }
    }

    /// Unfollow the specified scanlation group
    /// - Parameter groupId: The id of the scanlation group
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func unfollowGroup(groupId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.unfollowGroup(groupId: groupId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

}
