//
//  MDAggregate.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an aggregation of volumes and chapters returned by MangaDex
public struct MDAggregate: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// The list of aggregated volumes and chapters
    public let volumes: [String: MDAggregatedVolume]

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case volumes
    }

}

/// Structure representing a volume and its chapters returned by MangaDex
public struct MDAggregatedVolume: Decodable {

    /// This volume's number
    public let volume: String

    /// The number of aggregated chapters for this volume
    public let count: Int

    /// The list of aggregated chapters for this volume
    public let chapters: [String: MDAggregatedChapter]

}

/// Structure representing a volume and its chapters returned by MangaDex
public struct MDAggregatedChapter: Decodable {

    /// This chapter's number
    public let chapter: String

    /// The number of aggregated chapters
    public let count: Int

}
