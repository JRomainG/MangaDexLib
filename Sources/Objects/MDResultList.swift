//
//  MDResultList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a list of results returned by the MangaDex API
public struct MDResultList<T: Decodable>: Decodable {

    /// The status of the result returned by the MangaDex API
    public let results: [MDResult<T>]

    /// The maximum number of results returned by the MangaDex API
    public let limit: Int

    /// The offset of the first returned result
    ///
    /// This is used for paging when there are too many results to return in one response
    public let offset: Int

    /// The total number of available results
    public let total: Int

}
