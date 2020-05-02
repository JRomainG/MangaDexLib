//
//  MDPath+Chapter.swift
//  MangaDexLib-iOS
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to fetch information about a given chapter
    /// - Parameter chapterId: The identifier of the chapter
    /// - Parameter server: The server from which to load images
    /// - Returns: The MangaDex URL
    public static func chapterInfo(chapterId: Int, server: MDServer) -> URL {
        let params = [
            URLQueryItem(name: ApiParam.id.rawValue, value: String(chapterId)),
            URLQueryItem(name: ApiParam.server.rawValue, value: server.rawValue),
            URLQueryItem(name: ApiParam.type.rawValue, value: ResourceType.chapter.rawValue)
        ]

        // When the server is set to automatic, its value is ""
        // and we don't want to send it to the API, so set keepEmpty to false
        return MDPath.buildUrl(for: .api, with: params, keepEmpty: false)
    }

    /// Build the URL to the given page's image
    /// - Parameter server: The base URL for the server
    /// - Parameter hash: The chapter's hash
    /// - Parameter page: The page's file name
    /// - Returns: The image's URL
    public static func chapterPage(server: String, hash: String, page: String) -> URL {
        var url = URL(string: server)!
        url = url.appendingPathComponent(hash)
        return url.appendingPathComponent(page)
    }

    /// Build the URL to fetch a given chapter's comments
    /// - Parameter chapterId: The identifier of the chapter
    /// - Returns: The MangaDex URL
    public static func chapterComments(chapterId: Int) -> URL {
        let components: [String] = [String(chapterId), ResourceType.comments.rawValue]
        return buildUrl(for: .chapterPage, with: components)
    }

}
