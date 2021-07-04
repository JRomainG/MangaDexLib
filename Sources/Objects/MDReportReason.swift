//
//  MDReportReason.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 04/07/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a reason for which to report an entry hosted on MangaDex
public struct MDReportReason: Decodable {

    /// A description of the report reason
    public let reason: MDLocalizedString

    /// Whether the user must enter details when sending this kind of report
    public let detailsRequired: Bool

    /// The type of object this reason applies to
    public let category: MDObjectType

    /// The version of this type of object in the MangaDex API
    public let version: Int

}
