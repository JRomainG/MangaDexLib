//
//  MDConstants.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Cookie saving the user's choice regarding the display of rated manga
public enum MDRatedFilter: Int {
    /// Only show unrated mangas (Default)
    case noR18 = 0

    /// Show both rated and unrated mangas
    case all = 1

    /// Only show rated mangas (aka hentai)
    case onlyR18 = 2
}

/// Available MangaDex servers to fetch chapter pages from
public enum MDServer: String {
    /// Automatically select the best server (Default)
    case automatic = ""

    /// Use the first NA/EU serveur
    case naEu1 = "na"

    /// Use the second NA/EU serveur
    case naEu2 = "na2"

    // The following options are currently disabled on the website
    //case europe = "eu"
    //case europe2 = "eu2"
    //case restOfTheWorld = "row"
}

/// Existing user ranks
public enum MDRank: String, Codable {
    /// Used has been banned from the website
    case banned = "banned"

    /// User hasn't verified their email
    case validating = "validating"

    /// User is a regular member
    case member = "member"

    /// User is leader of a group
    case groupLeader = "group_leader"

    /// User is a power chapter uploader
    case powerUploader = "power_uploader"

    /// User is VIP
    case vip = "vip"

    /// User is in charge of Public Relations for MangaDex
    case publicRelations = "public_relations"

    /// User is in charge of moderating forums
    case forumModerator = "forum_moderator"

    /// User is in charge of moderating the website
    case moderator = "moderator"

    /// User is a developer
    case developer = "developer"

    /// User in an administrator
    case administrator = "administrator"
}

/// The status of a manga or chapter
public enum MDStatus: String, Codable {
    /// The group has uploaded the chapter, but it's not yet available
    /// to read on MangaDex
    case pending = "delayed"

    /// The manga or chapter has been deleted
    case deleted = "deleted"

    /// The manga or chapter is available
    case released = "OK"

    /// There was an error with the request
    case error = "error"
}

/// The user-defined status of a manga
public enum MDReadingStatus: Int, Codable {
    /// The user is not following the manga
    case unfollowed = -1

    /// Status used when filtering followed manga
    case all = 0

    /// The user has bookmarked the manga
    case reading = 1

    /// The user has marked the manga as read
    case completed = 2

    /// The user has marked their reading of this manga as "on hold"
    case onHold = 3

    /// The user has marked this manga as to read later
    case planToRead = 4

    /// The user has marked this manga as dropped, and no longer reading
    case dropped = 5

    /// This user has marked that they are reading this chapter another time
    case reReading = 6
}

/// Sort orders available for the listed mangas
public enum MDSortOrder: Int, Codable {
    /// Show mangas updated the most recently first
    case recentlyUpdated = 0

    /// Show mangas updated the most recently last
    case oldestUpdated = 1

    /// Show mangas in alphabetical order
    case alphabetical = 2

    /// Show mangas in reverse alphabetical order
    case reverseAlphabetical = 3

    /// Show mangas with the most comments last
    case leastComments = 4

    /// Show mangas with the most comments first
    case mostComments = 5

    /// Show mangas with the best rating last
    case worstRating = 6

    /// Show mangas with the best rating first
    case bestRating = 7

    /// Show mangas with the most views last
    case leastViews = 8

    /// Show mangas with the most views first
    case mostViews = 9

    /// Show mangas with the most follows last
    case leastFollows = 10

    /// Show mangas with the most follows first
    case mostFollows = 11
}

/// Languages available on the MangaDex website
public enum MDLanguage: Int, Codable {
    case all = 0
    case english = 1
    case japanese = 2
    case polish = 3
    case serbocroatian = 4
    case dutch = 5
    case italian = 6
    case russian = 7
    case german = 8
    case hungarian = 9
    case french = 10
    case finnish = 11
    case vietnamese = 12
    case greek = 13
    case bulgarian = 14
    case spanish = 15
    case brasilianPortuguese = 16
    case portuguese = 17
    case swedish = 18
    case arabic = 19
    case danish = 20
    case simplifiedChinese = 21
    case bengali = 22
    case romanian = 23
    case czech = 24
    case mongolian = 25
    case turkish = 26
    case indonesian = 27
    case korean = 28
    case latinAmericanSpanish = 29
    case persian = 30
    case malay = 31
    case thai = 32
    case catalan = 33
    case filipino = 34
    case traditionalChinese = 35
    case ukrainian = 36
    case burmese = 37
    case lithuanian = 38
    case hebrew = 39
    case hindi = 40
    case other = 41
    case norwegian = 42
}

/// Mapping between the language codes and the associated `MDLanguage`
///
/// These codes are used by MangaDex's JSON api to return information about a
/// manga or chapter's original language.
/// Only a subset of the list of all languages exists
let MDLanguageCodes: [String: MDLanguage] = [
    "en": .english,
    "gb": .english,
    "jp": .japanese,
    "pl": .polish,
    "ru": .russian,
    "de": .german,
    "fr": .french,
    "vn": .vietnamese,
    "cn": .simplifiedChinese,
    "id": .indonesian,
    "kr": .korean,
    "th": .thai,
    "ph": .filipino,
    "mx": .latinAmericanSpanish,
    "hk": .traditionalChinese
]

/// Demographic a manga appeals to, available to filter during search
public enum MDDemographic: Int, Codable {
    /// The manga is a shounen, usually targeted at boys between 12 and 18
    case shounen = 1

    /// The manga is a shoujo, usually targeted at girls between 12 and 18
    case shoujo = 2

    /// The manga is a seinen, usually targeted at adult men
    case seinen = 3

    /// The manga is a josei, usually targeted at adult women
    case josei = 4
}

/// Status of a manga, available to filter during search
public enum MDPublicationStatus: Int, Codable {
    /// The manga is being regularly updated
    case ongoing = 1

    /// The manga is done
    case completed = 2

    /// The manga has been canceled
    case cancelled = 3

    /// The manga's publication has been paused
    case hiatus = 4
}

/// Tag representing a type of content, available to filter during search
///
/// Also see `MDFormat`, `MDGenre` and `MDTheme`
public enum MDContent: Int, Codable {
    case ecchi = 9
    case smut = 32
    case gore = 49
    case sexualViolence = 50
}

/// Tag representing a format of manga, available to filter during search
///
/// Also see `MDContent`, `MDGenre` and `MDTheme`
public enum MDFormat: Int, Codable {
    case yonkoma = 1
    case awardWinning = 4
    case doujinshi = 7
    case oneShot = 21
    case longStrip = 36
    case adaptation = 42
    case anthology = 43
    case webComic = 44
    case fullColor = 45
    case userCreated = 46
    case officialColored = 47
    case fanColored = 48
}

/// Tag representing a genre of manga, available to filter during search
///
/// Also see `MDContent`, `MDFormat` and `MDTheme`
public enum MDGenre: Int, Codable {
    case action = 2
    case adventure = 3
    case comedy = 5
    case drama = 8
    case fantasy = 10
    case historical = 13
    case horror = 14
    case mecha = 17
    case medical = 18
    case mystery = 20
    case psychological = 22
    case romance = 23
    case scifi = 25
    case shoujoAi = 28
    case shounenAi = 30
    case sliceOfLife = 31
    case sports = 33
    case tragedy = 35
    case yaoi = 37
    case yuri = 38
    case isekai = 41
    case crime = 51
    case magicalGirls = 52
    case philosophical = 53
    case superhero = 54
    case thriller = 55
    case wuxia = 56
}

/// Tag representing a theme appearing in a manga, available to filter during search
///
/// Also see `MDContent`, `MDFormat` and `MDGenre`
public enum MDTheme: Int, Codable {
    case cooking = 6
    case gyaru = 11
    case harem = 12
    case martialArts = 16
    case music = 19
    case schoolLife = 24
    case supernatural = 34
    case videoGames = 40
    case aliens = 57
    case animals = 58
    case crossdressing = 59
    case demons = 60
    case delinquents = 61
    case genderswap = 62
    case ghosts = 63
    case monsterGirls = 64
    case loli = 65
    case magic = 66
    case military = 67
    case monsters = 68
    case ninja = 69
    case officeWorkers = 70
    case police = 71
    case postApocalyptic = 72
    case reincarnation = 73
    case reverseHarem = 74
    case samurai = 75
    case shota = 76
    case survival = 77
    case timeTravel = 78
    case vampires = 79
    case traditionalGames = 80
    case virtualReality = 81
    case zombies = 82
    case incest = 83
    case mafia = 84
}

/// The complete list of existing tags
///
/// Also see `MDContent`, `MDFormat`, `MDGenre` and `MDTheme`
public let MDTags: [Int] = Array(MDFormat.yonkoma.rawValue...MDTheme.mafia.rawValue)
