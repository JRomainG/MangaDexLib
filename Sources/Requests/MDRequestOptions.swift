//
//  MDRequestOptions.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 01/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// A class representing options used when performing requests using `MDRequestHandler`
public class MDRequestOptions: NSObject {

    /// The different ways of encoding the data for POST requests
    public enum BodyEncoding {
        /// Encode data like JavaScript would
        ///
        /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
        case multipart

        /// Encode data like would be done if JavaScript is disabled
        ///
        /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
        case urlencoded
    }

    /// The encoding to use for the request, only for `POST` requests
    public var encoding: BodyEncoding?

    /// The referer for this request
    public var referer: String?

    /// Convenience init method for get requests
    init(referer: String?) {
        self.referer = referer
    }

    /// Convenience init method
    init(encoding: BodyEncoding, referer: String?) {
        self.encoding = encoding
        self.referer = referer
    }

}
