//
//  MDResponse.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// A class representing a response returned from the MDApi
public class MDResponse: NSObject {

    /// The types of MDResponse the API can return
    public enum ResponseType {
        case generic
        case mangaInfo
        case mangaList
        case chapterInfo
        case chapterList
        case groupInfo
        case commentList
        case login
        case logout
    }

    /// The type of response this is
    public private(set) var type: ResponseType = .generic

    /// The URL of the original request
    public private(set) var url: URL?

    /// The raw html or json string returned from the website (if any)
    public private(set) var rawValue: String?

    /// The error returned from the request (if any)
    public var error: Error?

    /// The status code of the response
    public var statusCode: Int?

    /// The extracted manga, if relevant
    public var manga: MDManga?

    /// The list of extracted mangas, if relevant
    public var mangas: [MDManga]?

    /// The extracted chapter, if relevant
    public var chapter: MDChapter?

    /// The list of extracted chapters, if relevant
    public var chapters: [MDChapter]?

    /// The extracted group, if relevant
    public var group: MDGroup?

    /// The list of extracted comments, if relevant
    public var comments: [MDComment]?

    /// The token returned by the request, if relevant
    public var token: String?

    /// Convenience init method
    init(type: ResponseType,
         url: URL? = nil,
         rawValue: String? = nil,
         error: Error? = nil,
         content: String? = nil,
         status: Int? = nil) {
        self.type = type
        self.url = url
        self.rawValue = rawValue
        self.error = error
        self.rawValue = content
        self.statusCode = status
    }

}
