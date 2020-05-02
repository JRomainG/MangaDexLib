//
//  MDPath+Misc.swift
//  MangaDexLib-iOS
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL for performing a search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Returns: The MangaDex URL
    public static func search(_ search: MDSearch) -> URL {
        // The include and exclude tags are actually bundled in the same list,
        // Exclude tags are simply preceded by a "-". First build each string
        let includeTags = search.includeTags.map { String($0) }.joined(separator: ",")
        let excludeTags = search.excludeTags.map { String(-$0) }.joined(separator: ",")

        // Then, join both strings together in a nice way
        let tags: String?
        if includeTags.count > 0 && excludeTags.count > 0 {
            tags = "\(includeTags),\(excludeTags)"
        } else if includeTags.count > 0 {
            tags = includeTags
        } else if excludeTags.count > 0 {
            tags = excludeTags
        } else {
            tags = nil
        }

        // Build the other lists of ids, which are simpler
        let demos = search.demographics.map { String($0.rawValue) }.joined(separator: ",")
        let statuses = search.publicationStatuses.map { String($0.rawValue) }.joined(separator: ",")

        // The language is an int, but has to be converted to a string
        let lang: String?
        if search.originalLanguage != nil {
            lang = String(search.originalLanguage!.rawValue)
        } else {
            lang = nil
        }

        // Build the list of params using URLQueryItem, as they are automatically escaped
        let params = [
            URLQueryItem(name: SearchParam.title.rawValue, value: search.title),
            URLQueryItem(name: SearchParam.author.rawValue, value: search.author),
            URLQueryItem(name: SearchParam.artist.rawValue, value: search.artist),
            URLQueryItem(name: SearchParam.originalLanguage.rawValue, value: lang),
            URLQueryItem(name: SearchParam.demographics.rawValue, value: demos),
            URLQueryItem(name: SearchParam.publicationStatuses.rawValue, value: statuses),
            URLQueryItem(name: SearchParam.tags.rawValue, value: tags),
            URLQueryItem(name: SearchParam.includeTagsMode.rawValue, value: search.includeTagsMode.rawValue),
            URLQueryItem(name: SearchParam.excludeTagsMode.rawValue, value: search.excludeTagsMode.rawValue)
        ]
        return MDPath.buildUrl(for: .searchMangas, with: params, keepEmpty: false)
    }

    /// Build the URL to fetch a thread's content
    /// - Parameter threadId: The identifier of the thread
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    ///
    /// A thread represents a full chain of comments in chronological order.
    /// `mangaComments` and `chapterComments` are only URLs to the page with
    /// the latest comments
    public static func thread(threadId: Int, page: Int) -> URL {
        return buildUrl(for: .thread, with: [threadId, page])
    }

    /// Build the URL to fetch information about a given group
    /// - Parameter groupId: The identifier of the group
    /// - Returns: The MangaDex URL
    public static func groupInfo(groupId: Int) -> URL {
        return buildUrl(for: .groupPage, with: [groupId])
    }

    /// Build the URL to fetch a user's MDList
    /// - Parameter userId: The identifier of the user
    /// - Parameter status: The status of the mangas to fetch (shouldn't be `.unfollowed`)
    /// - Returns: The MangaDex URL
    public static func mdList(userId: Int, status: MDReadingStatus) -> URL {
        return buildUrl(for: .mdList, with: [userId, status.rawValue])
    }

    /// Build the URL of the login page
    /// - Returns: The MangaDex URL
    ///
    /// - Note: This is only used to set the "Referer" field in requests
    public static func login() -> URL {
        return buildUrl(for: .login)
    }

    /// Build the URL to an external resource
    /// - Parameter resource: The type of external website
    /// - Parameter path: The ID or absolute URL for the resource
    /// - Returns: The external URL
    public static func externalResource(resource: MDResource, path: String) -> URL? {
        // Handle cases where the resource is only a relative URL, which means the resource's
        // raw value contains the base URL for the resource
        var absoluteURL: String
        if let baseURL = resource.baseURL {
            // Can't use "appendingPathComponent" as URLs may expect a get parameter
            // Instead, just append the string to the base URL
            guard let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return nil
            }
            absoluteURL = baseURL + escapedPath
        } else {
            absoluteURL = path
        }
        return URL(string: absoluteURL)
    }

}
