//
//  MDSearch.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a search query
class MDSearch: NSObject {

    /// Demographic a manga appeals to, available to filter during search
    enum Demographic: Int {
        case shounen = 1
        case shoujo = 2
        case seinen = 3
        case josei = 4
    }

    /// Status of a manga, available to filter during search
    enum PublicationStatus: Int {
        case ongoing = 1
        case completed = 2
        case cancelled = 3
        case hiatus = 4
    }

    /// Tag representing a type of content, available to filter during search
    enum Content: Int {
        case ecchi = 9
        case smut = 32
        case gore = 49
        case sexualViolence = 50
    }

    /// Tag representing a format of manga, available to filter during search
    enum Format: Int {
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
    enum Genre: Int {
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
    enum Theme: Int {
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

    // swiftlint:disable redundant_string_enum_value
    /// Type of filtering when searching with tags
    enum TagFilteringMode: String {
        case any = "any"
        case all = "all"
    }
    // swiftlint:enable redundant_string_enum_value

    /// Type of parameter using during the request for search
    enum Parameter: String {
        case title = "title"
        case author = "author"
        case artist = "artist"
        case originalLanguage = "lang_id"
        case demographics = "demos"
        case publicationStatuses = "statuses"
        case tags = "tags"
        case includeTagsMode = "tag_mode_inc"
        case excludeTagsMode = "tag_mode_exc"
    }

    /// Options available to select as a work's original language during search
    let originalLanguages: [Language] = [
        .english,
        .japanese,
        .polish,
        .russian,
        .german,
        .french,
        .vietnamese,
        .simplifiedChinese,
        .indonesian,
        .korean,
        .latinAmericanSpanish,
        .thai,
        .filipino,
        .traditionalChinese
    ]

    /// Title to lookup (nil means no filter)
    var title: String?

    /// Author to lookup (nil means no filter)
    var author: String?

    /// Artist to lookup (nil means no filter)
    var artist: String?

    /// Original language of the  mangas to lookup (nil means any)
    var originalLanguage: Language?

    /// Demographics of the  mangas to lookup (empty means no filter)
    var demographics: [Demographic] = []

    /// Publication status of the  mangas to lookup (empty means no filter)
    var publicationStatuses: [PublicationStatus] = []

    /// Tags to allow in the mangas to lookup (empty means no filter)
    var includeTags: [Int] = []

    /// Tags to forbid in the mangas to lookup (empty means no filter)
    var excludeTags: [Int] = []

    /// Type of filter to apply for tag inclusion
    var includeTagsMode: TagFilteringMode = .all

    /// Type of filter to apply for tag exclusion
    var excludeTagsMode: TagFilteringMode = .any

    /// Convenience method to init an empty search instance
    override init() {
    }

    /// Convenience method to init a simple search instance
    init(title: String?) {
        self.title = title
    }

    /// Convenience method to init an advanced search instance
    init(title: String?,
         author: String?,
         artist: String?,
         originalLanguage: Language?,
         demographics: [Demographic],
         publicationStatuses: [PublicationStatus],
         includeTags: [Int],
         excludeTags: [Int],
         includeTagsMode: TagFilteringMode,
         excludeTagsMode: TagFilteringMode) {
        self.title = title
        self.author = author
        self.artist = artist
        self.originalLanguage = originalLanguage
        self.demographics = demographics
        self.publicationStatuses = publicationStatuses
        self.includeTags = includeTags
        self.excludeTags = excludeTags
        self.includeTagsMode = includeTagsMode
        self.excludeTagsMode = excludeTagsMode
    }
}
