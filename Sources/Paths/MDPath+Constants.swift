//
//  MDPath+Constants.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 01/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Relative paths to the pages on MangaDex
    enum Endpoint: String {
        /// Endpoint for manga objects
        case manga = "manga"

        /// Endpoint for chapter objects
        case chapter = "chapter"

        /// Endpoint for cover objects
        case cover = "cover"

        /// Endpoint for author objects
        case author = "author"

        /// Endpoint for scanlation group objects
        case group = "group"

        /// Endpoint for list objects
        case customList = "list"

        /// Endpoint for user information
        case user = "user"

        /// Endpoint for authentication
        case auth = "auth"

        /// Endpoint for account management
        case account = "account"

        /// Endpoint for captcha challenges
        case captcha = "captcha"

        /// Endpoint for MD@Home
        case atHome = "at-home"

        /// Endpoint for MD@Home statistics reports
        case atHomeReport = "report"

        /// Endpoint for legacy object mappings
        case legacy = "legacy"

        /// Endpoint for legacy object mappings
        case ping = "ping"
    }

}
