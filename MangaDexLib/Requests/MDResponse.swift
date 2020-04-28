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
    }

    /// The type of response this is
    private(set) var type: ResponseType = .generic

    /// The raw html or json string returned from the website (if any)
    private(set) var rawValue: String?

    /// The error returned from the request (if any)
    var error: Error?

    /// The list of extract ids, if relevant
    var idList: [Int]?

    /// Convenience init method
    init(type: ResponseType, rawValue: String?, error: Error?) {
        self.type = type
        self.rawValue = rawValue
        self.error = error
    }

}
