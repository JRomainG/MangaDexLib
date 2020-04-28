//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

class MDApi: NSObject {

    /// URL for the MangaDex website
    static let baseURL = "https://mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    static let defaultUserAgent = "MangaDexLib"

    let requestHandler = MDRequestHandler()

}
