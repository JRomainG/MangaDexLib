//
//  MDApi+User.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of users
    /// - Parameter filter: The filter to use
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getUserList(filter: MDUserFilter? = nil,
                            completion: @escaping (MDResultList<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.getUserList(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the specified user's information
    /// - Parameter userId: The id of the user
    /// - Parameter completion: The completion block called once the request is done
    public func viewUser(userId: String, completion: @escaping (MDResult<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.viewUser(userId: userId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the specified user's custom lists
    /// - Parameter userId: The id of the user
    /// - Parameter pagination: The pagination filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getUserCustomLists(userId: String,
                                   pagination: MDPaginationFilter? = nil,
                                   completion: @escaping (MDResultList<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.getUserCustomLists(userId: userId, pagination: pagination)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the logged-in user's information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func viewLoggedUser(completion: @escaping (MDResult<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.viewLoggedUser()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the logged-in user's password
    /// - Parameter old: The user's old password
    /// - Parameter new: The user's new password
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateLoggedUserPassword(old: String, new: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.updateLoggedUserPassword()
        let data = [
            "oldPassword": old,
            "newPassword": new
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

    /// Update the logged-in user's email address
    /// - Parameter new: The user's new email address
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateLoggedUserEmail(email: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.updateLoggedUserEmail()
        let data = [
            "email": email
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

    /// Get the list of mangas followed by the logged-in user
    /// - Parameter pagination: The pagination filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedMangaList(pagination: MDPaginationFilter? = nil,
                                               completion: @escaping (MDResultList<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedMangaList(pagination: pagination)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the logged-in user's followed manga feed (aka their list of recent chapters)
    /// - Parameter filter: The filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedMangaFeed(filter: MDFeedFilter? = nil,
                                               completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedMangaFeed(filter: filter)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of scanlation groups followed by the logged-in user
    /// - Parameter pagination: The pagination filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedGroupList(pagination: MDPaginationFilter? = nil,
                                               completion: @escaping (MDResultList<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedGroupList(pagination: pagination)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of users followed by the logged-in user
    /// - Parameter pagination: The pagination filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedUserList(pagination: MDPaginationFilter? = nil,
                                              completion: @escaping (MDResultList<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedUserList(pagination: pagination)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the logged-in user's custom lists
    /// - Parameter pagination: The pagination filter to apply
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserCustomLists(pagination: MDPaginationFilter? = nil,
                                         completion: @escaping (MDResultList<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserCustomLists(pagination: pagination)
        performBasicGetCompletion(url: url, completion: completion)
    }

}
