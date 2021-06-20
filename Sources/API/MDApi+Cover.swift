//
//  MDApi+Cover.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 05/06/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of latest published covers
    /// - Parameter filter: The filter to use
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func getCoverList(filter: MDCoverFilter? = nil,
                             includes: [MDObjectType]? = nil,
                             completion: @escaping (MDResultList<MDCover>?, MDApiError?) -> Void) {
        let url = MDPath.getCoverList(filter: filter, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// View the specified cover's information
    /// - Parameter coverId: The id of the cover
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func viewCover(coverId: String,
                          includes: [MDObjectType]? = nil,
                          completion: @escaping (MDResult<MDCover>?, MDApiError?) -> Void) {
        let url = MDPath.viewCover(coverId: coverId, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Update the specified cover's information
    /// - Parameter coverId: The id of the cover
    /// - Parameter info: The cover information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateCover(coverId: String,
                            info: MDCover,
                            completion: @escaping (MDResult<MDCover>?, MDApiError?) -> Void) {
        let url = MDPath.updateCover(coverId: coverId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }

    /// Delete the specified cover
    /// - Parameter coverId: The id of the cover
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteCover(coverId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteCover(coverId: coverId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }

}
