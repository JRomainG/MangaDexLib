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

    /// The URL of the original request
    public private(set) var url: URL

    /// The json string returned from the website (if any)
    public private(set) var content: String

    /// The error returned from the request (if any)
    public var error: MDApiError?

    /// The status code of the response
    public var statusCode: Int?

    /// Convenience init method
    init(url: URL,
         content: String?,
         error: MDApiError? = nil,
         status: Int? = nil) {
        self.url = url
        self.content = content ?? ""
        self.error = error
        self.statusCode = status
    }

}
