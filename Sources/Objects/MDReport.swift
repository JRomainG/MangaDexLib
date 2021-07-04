//
//  MDReport.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 04/07/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a report about an entry hosted on the MangaDex website
public struct MDReport: Encodable {

    /// The type of object this report applies to
    public let category: MDObjectType

    /// The ID of the MDReportReason for which this entry is being reported
    public let reasonId: String

    /// The ID of the entry being reported
    public let objectId: String

    /// User-entered details about this report
    /// - Note:
    /// Required if the associated `MDReportReason` has `detailsRequired` set to `true`
    public let details: String

    /// Convenience init to send a report
    public init(category: MDObjectType, reasonId: String, objectId: String, details: String? = nil) {
        self.category = category
        self.reasonId = reasonId
        self.objectId = objectId
        self.details = details ?? ""
    }

}

extension MDReport {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case category
        case reasonId = "reason"
        case objectId
        case details
    }

}
