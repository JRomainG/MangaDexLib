//
//  MDApi+Infra.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the MD@Home node URL hosting the specified chapter's page images
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    ///
    /// If you do not want to use a MD@Home node, you can use one of the values of the `MDImageServer` enum
    /// Also see `MDChapter.getPageUrls`
    /// - Precondition: The user must be logged-in
    public func getChapterServer(chapterId: String, completion: @escaping (MDAtHomeNode?, MDApiError?) -> Void) {
        let url = MDPath.getAtHomeNodeURL(chapterId: chapterId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Ping the MangaDex website to ensure it is up
    /// - Parameter completion: The completion block called once the request is done
    public func ping(completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.ping()
        performGet(url: url) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(response.error)
                return
            }
            completion(nil)
        }
    }

}
