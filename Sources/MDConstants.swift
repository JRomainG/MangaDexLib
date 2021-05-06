//
//  MDConstants.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation


/// Demographic a manga appeals to
public enum MDDemographic: String, Codable {
    /// The manga is a shounen, usually targeted at boys between 12 and 18
    case shounen = "shonen"

    /// The manga is a shoujo, usually targeted at girls between 12 and 18
    case shoujo = "shoujo"

    /// The manga is a seinen, usually targeted at adult men
    case seinen = "josei"

    /// The manga is a josei, usually targeted at adult women
    case josei = "seinen"
}

/// Publication status of a manga
public enum MDPublicationStatus: String, Codable {
    /// The manga is being regularly updated
    case ongoing = "ongoing"

    /// The manga is done
    case completed = "completed"

    /// The manga's publication has been paused
    case hiatus = "hiatus"

    /// The manga has been canceled
    case abandoned = "abandoned"
}

/// User-defined status of a manga
public enum MDReadingStatus: String, Codable {
    /// The user has bookmarked the manga
    case reading = "reading"

    /// The user has marked their reading of this manga as "on hold"
    case onHold = "on_hold"

    /// The user has marked this manga as to read later
    case planToRead = "plan_to_read"

    /// The user has marked this manga as dropped, and no longer reading
    case dropped = "dropped"

    /// This user has marked that they are reading this chapter another time
    case reReading = "re_reading"

    /// The user has marked the manga as read
    case completed = "completed"
}

/// Rating of a manga's content
public enum MDContentRating: String, Codable {
    /// The manga only has safe content
    case safe = "safe"

    /// The manga has suggestive content
    case suggestive = "suggestive"

    /// The manga has erotic content
    case erotica = "erotica"

    /// The manga has pornographic content
    case pornographic = "pornographic"
}

/// Visibility of a user's custom list
public enum MDCustomListVisibility: String, Codable {
    /// The list is visible to everyone
    case publicList = "public"

    /// The list is only visible to its owner
    case privateList = "private"
}

/// Type of resource linked by a relationship
public enum MDRelationshipType: String, Codable {
    /// The target resource is a manga
    case manga = "manga"

    /// The target resource is a chapter
    case chapter = "chapter"

    /// The target resource is an author
    case author = "author"

    /// The target resource is an artist (drawers only)
    case artist = "artist"

    /// The target resource is a scanlation group
    case scanlationGroup = "scanlation_group"

    /// The target resource is a tag
    case tag = "tag"

    /// The target resource is a user
    case user = "user"

    /// The target resource is a user's custom list
    case customList = "custom_list"
}

/// Tag filtering mode (used to include or exclude tags during search)
public enum MDTagMode: String, Codable {
    /// Exclude/Include only all tags are present
    case all = "AND"

    /// Exclude/Include if any tag is present
    case any = "OR"
}

/// Criteria to use when sorting objects
public enum MDSortCriteria: String, Codable {
    /// Sort depending on creation date
    case creationDate = "createdAt"

    /// Sort depending on the date of the last released update
    case lastUpdate = "updatedAt"
}

/// Sort order for lists of objects
public enum MDSortOrder: String, Codable {
    /// Sort by ascending
    case ascending = "asc"

    /// Sort by descending
    case descending = "desc"
}
