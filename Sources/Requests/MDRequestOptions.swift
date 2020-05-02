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

    /// The value to set for the "X-Requested-With" header
    ///
    /// For `POST` methods, the default is `XMLHttpRequest`, and
    /// for `GET` methods the default is nil
    public var requestedWith: String?

    /// Convenience init method for get requests
    init(referer: String?, requestedWith: String? = nil) {
        self.referer = referer
        self.requestedWith = requestedWith
    }

    /// Convenience init method
    init(encoding: BodyEncoding, referer: String?, requestedWith: String? = "XMLHttpRequest") {
        self.encoding = encoding
        self.referer = referer
    }

}
