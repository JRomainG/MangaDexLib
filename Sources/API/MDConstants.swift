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
    case shounen = "shounen"

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
    case cancelled = "cancelled"
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
    /// Used only for filtering by content rating
    case none = "none"

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

/// Type of object which exists in the MangaDex API
public enum MDObjectType: String, Codable {
    /// The resource is a manga
    case manga = "manga"

    /// The resource is a chapter
    case chapter = "chapter"

    /// A cover art for a manga
    case cover_art = "cover_art"

    /// The resource is an author
    case author = "author"

    /// The resource is an artist (drawers only)
    case artist = "artist"

    /// The resource is a scanlation group
    case scanlationGroup = "scanlation_group"

    /// The resource is a tag
    case tag = "tag"

    /// The resource is a user
    case user = "user"

    /// The resource is a user's custom list
    case customList = "custom_list"

    /// The resource is a mapping between a legacy ID and a new ID
    case legacyMapping = "mapping_id"

    /// The resource is a string
    case string = "string"
}

/// Tag filtering mode (used to include or exclude tags during search)
public enum MDTagFilteringMode: String, Codable {
    /// Exclude/include mangas with any of the given tags
    case any = "OR"

    /// Only exclude/include mangas with all of the given tags
    case all = "AND"
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

/// Types of external links provided by MangaDex
public enum MDExternalLinkType: String, Codable {
    /// Links to anilist.co
    case aniList = "al"

    /// Links to anime-planet.com
    case animePlanet = "ap"

    /// Links to bookwalker.jp to purchase the manga
    case bookWalker = "bw"

    /// Links to mangaupdates.com
    case mangaUpdates = "mu"

    /// Links to novelupdates.com
    case novelUpdates = "nu"

    /// Links to kitsu.io
    case kitsu = "kt"

    /// Links to Amazon to purchase the mange
    case amazon = "amz"

    /// Links to eBookJapan to purchase the manga
    case eBookJapan = "ebj"

    /// Links to myanimelist.net
    case myAnimeList = "mal"

    /// Links to the original work
    case raw = "raw"

    /// Links to the official english translation
    case officialTranslation = "engtl"
}

/// Types of result status the MangaDex API may return
public enum MDResultStatus: String, Codable {
    /// The result contains valid data
    case ok

    /// The result contains at least one error
    case error = "error"
}

/// Roles returned by the MangaDex API in token information
///
/// **TODO**: This list might not be accurate as it is not described in the API documentation
public enum MDRole: String, Codable {
    /// The user is anonymous
    case anonymous = "IS_ANONYMOUS"

    /// The user is authenticated without an account
    /// - Note: Logged-in users still have this "role" as roles stack
    case authenticatedAnonymously = "IS_AUTHENTICATED_ANONYMOUSLY"

    /// The user is logged-in to a validated account
    case authenticatedFully = "IS_AUTHENTICATED_FULLY"

    /// The user is logged-in to an account and will be remebered
    case authenticatedRemembered = "IS_AUTHENTICATED_REMEMBERED"

    /// The user was authenticated using a JSON Web Token
    case authenticatedJwt = "IS_JWT_AUTHENTICATED"

    /// The user is a guest
    case guest = "ROLE_GUEST"

    /// The user is banned
    case banned = "ROLE_BANNED"

    /// The user is a member
    case member = "ROLE_MEMBER"

    /// The user is a member of at least one group
    case groupMember = "ROLE_GROUP_MEMBER"

    /// The user is leader of at least one group
    case groupLeader = "ROLE_GROUP_LEADER"

    /// The user is a power uploader
    case powerUploader = "ROLE_POWER_UPLOADER"

    /// The user is a VIP member
    case vip = "ROLE_VIP"

    /// The user is in charge of Public Relations for MangaDex
    case publicRelations = "ROLE_PUBLIC_RELATIONS"

    /// The user is in charge of moderating the MangaDex forum
    case forumModerator = "ROLE_FORUM_MODERATOR"

    /// The user is a developer for MangaDex
    case developer = "ROLE_DEVELOPER"

    /// The user is in charge of moderating the MangaDex website
    case moderator = "ROLE_MODERATOR"

    /// The user is a MangaDex administrator
    case administrator = "ROLE_ADMINISTRATOR"
}

/// Permissions returned by the MangaDex API in token information
///
/// **TODO**: This list might not be accurate as it is not described in the API documentation
public enum MDPermission: String, Codable {
    /// The logged-in user is allowed to view mangas
    case viewManga = "manga.view"

    /// The logged-in user is allowed to view chapters
    case viewChapter = "chapter.view"

    /// The logged-in user is allowed to view authors
    case viewAuthor = "author.view"

    /// The logged-in user is allowed to view scanlation groups
    case viewScanlationGroup = "scanlation_group.view"

    /// The logged-in user is allowed to view user information
    case viewUser = "user.view"

    /// The logged-in user is allowed to view covers
    case viewCover = "cover.view"

    /// The logged-in user is allowed to list mangas
    case listMangas = "manga.list"

    /// The logged-in user is allowed to list chapters
    case listChapters = "chapter.list"

    /// The logged-in user is allowed to list authors
    case listAuthors = "author.list"

    /// The logged-in user is allowed to list scanlation groups
    case listScanlationGroups = "scanlation_group.list"

    /// The logged-in user is allowed to list users
    case listUsers = "user.list"

    /// The logged-in user is allowed to list covers
    case listCovers = "cover.list"

    /// The logged-in user is allowed to create mangas
    case createManga = "manga.create"

    /// The logged-in user is allowed to upload chapters
    case uploadChapter = "chapter.upload"

    /// The logged-in user is allowed to upload chapters in the name of a group
    case groupUploadChapter = "group_self.upload"

    /// The logged-in user is allowed to upload chapters
    case remoteUploadChapter = "chapter.remote_upload"

    /// The logged-in user is allowed to upload covers
    case uploadCover = "cover.upload"

    /// The logged-in user is allowed to create authors
    case createAuthor = "author.create"

    /// The logged-in user is allowed to create scanlation groups
    case createScanlationGroup = "scanlation_group.create"

    /// The logged-in user is allowed to create users
    case createUser = "user.create"

    /// The logged-in user is allowed to delete mangas
    case deleteManga = "manga.delete"

    /// The logged-in user is allowed to delete chapters
    case deleteChapter = "chapter.delete"

    /// The logged-in user is allowed to delete authors
    case deleteAuthor = "author.delete"

    /// The logged-in user is allowed to delete scanlation groups
    case deleteScanlationGroup = "scanlation_group.delete"

    /// The logged-in user is allowed to delete users
    case deleteUser = "user.delete"

    /// The logged-in user is allowed to delete covers
    case deleteCover = "cover.delete"

    /// The logged-in user is allowed to update mangas
    case editManga = "manga.update"

    /// The logged-in user is allowed to update chapters
    case editChapter = "chapter.update"

    /// The logged-in user is allowed to update authors
    case editAuthor = "author.update"

    /// The logged-in user is allowed to update scanlation groups
    case editScanlationGroup = "scanlation_group.update"

    /// The logged-in user is allowed to update users
    case editUser = "user.update"

    /// The logged-in user is allowed to update covers
    case coverUser = "cover.update"
}

/// Known "official" MangaDex image servers
///
/// These can be useful if you do not want to use a MD@Home node
public enum MDImageServer: String, Codable {

    /// Image server s2
    case s2 = "https://s2.mangadex.org"

    /// Image server s5
    /// - Important: The certificate of this server is currently expired so it cannot be used
    case s5 = "https://s5.mangadex.org"

}

/// Sizes/Resolutions available for covers
public enum MDCoverSize: String, Codable {

    /// The original/best quality cover size
    case original = "original"

    /// A 512px wide thumbnail
    case medium = "512px"

    /// A 256px wide thumbnail
    case small = "256px"

}
