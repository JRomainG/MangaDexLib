//
//  MDAtHomeReport.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a report which must be sent after loading an image using the API
public struct MDAtHomeReport: Encodable {

    /// The URL of the image
    public let url: URL

    /// Whether the image successfully loaded
    public let success: Bool

    /// Whether the server returned an `X-Cache` header with a value starting with HIT
    public let cached: Bool

    /// The size (in bytes) of the retrieved image
    public let bytes: Int

    /// The time (in miliseconds) that the complete retrieval (not TTFB) of this image took
    public let duration: Int

    /// Convenience init to send a report
    public init (url: URL, success: Bool, cached: Bool, bytes: Int, duration: Int) {
        self.url = url
        self.success = success
        self.cached = cached
        self.bytes = bytes
        self.duration = duration
    }

}
