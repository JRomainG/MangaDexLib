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
        case mangaList
        case mangaInfo
    }

    /// The type of response this is
    private(set) var type: ResponseType = .generic

    /// The URL of the original request
    private(set) var url: URL

    /// The raw html or json string returned from the website (if any)
    private(set) var rawValue: String?

    /// The error returned from the request (if any)
    var error: Error?

    /// The list of extracted mangas, if relevant
    var mangas: [MDManga]?

    /// The extracted manga, if relevant
    var manga: MDManga?

    /// Convenience init method
    init(type: ResponseType, url: URL, rawValue: String?, error: Error?) {
        self.type = type
        self.url = url
        self.rawValue = rawValue
        self.error = error
    }

}
