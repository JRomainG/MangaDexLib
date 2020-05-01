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
        /// Generic response, for example to indicate that login is required
        case generic

        /// Response to a manga info or details request
        case mangaInfo

        /// Response to a request for a list of mangas
        case mangaList

        /// Response to a chapter info request
        case chapterInfo

        /// Response to a request for a list of chapters
        case chapterList

        /// Response to a group info request
        case groupInfo

        /// Response to a request for a list of comments or a thread
        case commentList

        /// Response to a login attemps
        case login

        /// Response to a logout attempt
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
    ///
    /// Usually set for `ResponseType.mangaInfo` requests
    public var manga: MDManga?

    /// The list of extracted mangas, if relevant
    ///
    /// Usually set for `ResponseType.mangaList` requests
    public var mangas: [MDManga]?

    /// The extracted chapter, if relevant
    ///
    /// Usually set for `ResponseType.chapterInfo` requests
    public var chapter: MDChapter?

    /// The list of extracted chapters, if relevant
    ///
    /// Usually set for `ResponseType.chapterList` requests
    public var chapters: [MDChapter]?

    /// The extracted group, if relevant
    ///
    /// Usually set for `ResponseType.groupInfo` requests
    public var group: MDGroup?

    /// The list of extracted comments, if relevant
    ///
    /// Usually set for `ResponseType.commentList` requests
    public var comments: [MDComment]?

    /// The token returned by the request, if relevant
    ///
    /// Usually set for `ResponseType.login` requests
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
