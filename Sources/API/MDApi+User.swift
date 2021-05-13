//
//  MDApi+User.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// View the specified user's information
    /// - Parameter userId: The id of the user
    /// - Parameter completion: The completion block called once the request is done
    public func viewUser(userId: String, completion: @escaping (MDResult<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.viewUser(userId: userId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the specified user's custom lists
    /// - Parameter userId: The id of the user
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getUserCustomLists(userId: String,
                                   completion: @escaping (MDResultList<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.getUserCustomLists(userId: userId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the logged-in user's information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func viewLoggedUser(completion: @escaping (MDResult<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.viewLoggedUser()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of mangas followed by the logged-in user
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedMangaList(completion: @escaping (MDResultList<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedMangaList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the logged-in user's followed manga feed (aka their list of recent chapters)
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedMangaFeed(completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedMangaFeed()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of scanlation groups followed by the logged-in user
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedGroupList(completion: @escaping (MDResultList<MDGroup>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedGroupList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of users followed by the logged-in user
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserFollowedUserList(completion: @escaping (MDResultList<MDUser>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserFollowedUserList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the logged-in user's custom lists
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func getLoggedUserCustomLists(completion: @escaping (MDResultList<MDCustomList>?, MDApiError?) -> Void) {
        let url = MDPath.getLoggedUserCustomLists()
        performBasicGetCompletion(url: url, completion: completion)
    }

}
