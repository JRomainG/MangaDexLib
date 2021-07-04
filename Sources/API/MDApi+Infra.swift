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
    /// - Parameter forcePort443: Force selecting from MangaDex@Home servers that use the standard HTTPS port 443.
    ///   This might be useful for networks with aggressive firewalls (e.g. school/office networks)
    /// - Parameter completion: The completion block called once the request is done
    ///
    /// If you do not want to use a MD@Home node, you can use one of the values of the `MDImageServer` enum
    /// Also see `MDChapter.getPageUrls`
    /// - Precondition: The user must be logged-in
    public func getChapterServer(chapterId: String,
                                 forcePort443: Bool = false,
                                 completion: @escaping (MDAtHomeNode?, MDApiError?) -> Void) {
        let url = MDPath.getAtHomeNodeURL(chapterId: chapterId, forcePort443: forcePort443)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Send a report after fetching an image from a MD@Home node
    /// - Parameter info: The report information
    /// - Parameter completion: The completion block called once the request is done
    public func sendAtHomeReport(info: MDAtHomeReport, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.sendAtHomeReport()
        performPost(url: url, body: info) { (response) in
            completion(response.error)
        }
    }

    /// Get a list of reasons for which the given type of object can be reported
    /// - Parameter objectType: The type of object for which to return existing report reasons
    /// - Parameter completion: The completion block called once the request is done
    public func getReportReasons(objectType: MDObjectType,
                                 completion: @escaping (MDObjectList<MDReportReason>?, MDApiError?) -> Void) {
        let url = MDPath.getReportReasons(objectType: objectType)
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Build the URL to report an entry hosted on the MangaDex website
    /// - Returns: The MangaDex URL
    public func createReport(info: MDReport, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.createReport()
        performPost(url: url, body: info) { (response) in
            completion(response.error)
        }
    }

    /// Get the mapping between legacy object IDs and new object IDs
    /// - Parameter query: The mappings to ask for
    /// - Parameter completion: The completion block called once the request is done
    public func getLegacyMapping(query: MDMappingQuery,
                                 completion: @escaping ([MDResult<MDMapping>]?, MDApiError?) -> Void) {
        let url = MDPath.getLegacyMapping()
        performBasicPostCompletion(url: url, data: query, completion: completion)
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

    /// Solve a captcha challenge sent by MangaDex
    /// - Parameter challenge: The solution to the challenge
    /// - Parameter completion: The completion block called once the request is done
    public func solveCaptcha(challenge: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.solveCaptcha()
        let data: [String: String] = [
            "captchaChallenge": challenge
        ]
        performPost(url: url, body: data) { (response) in
            completion(response.error)
        }
    }

}
