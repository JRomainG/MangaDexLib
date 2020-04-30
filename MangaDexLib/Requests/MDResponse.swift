//
//  MDResponse.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// A class representing a response returned from the MDApi
class MDResponse: NSObject {

    /// The types of MDResponse the API can return
    enum ResponseType {
        case generic
        case mangaInfo
        case mangaList
        case chapterInfo
        case groupInfo
        case commentList
        case login
        case logout
    }

    /// The type of response this is
    private(set) var type: ResponseType = .generic

    /// The URL of the original request
    private(set) var url: URL?

    /// The raw html or json string returned from the website (if any)
    private(set) var rawValue: String?

    /// The error returned from the request (if any)
    var error: Error?

    /// The status code of the response
    var statusCode: Int?

    /// The extracted manga, if relevant
    var manga: MDManga?

    /// The list of extracted mangas, if relevant
    var mangas: [MDManga]?

    /// The extracted chapter, if relevant
    var chapter: MDChapter?

    /// The extracted group, if relevant
    var group: MDGroup?

    /// The list of extracted comments, if relevant
    var comments: [MDComment]?

    /// The token returned by the request, if relevant
    var token: String?

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
