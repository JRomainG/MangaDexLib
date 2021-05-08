//
//  MDResultList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a list of results returned by the MangaDex API
struct MDResultList: Decodable {

    /// The status of the result returned by the MangaDex API
    let results: [MDResult]

    /// The maximum number of results returned by the MangaDex API
    let limit: Int

    /// The offset of the first return result
    ///
    /// This is used for paging when there are too many results to return in one response
    let offset: Int

    /// The total number of available results
    let total: Int

}
