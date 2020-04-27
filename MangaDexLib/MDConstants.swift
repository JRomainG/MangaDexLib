//
//  MDConstants.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Sort orders available for the listed mangas
enum SortOrder: Int {
    case recentlyUpdated = 0
    case oldestUpdated = 1
    case alphabetical = 2
    case reverseAlphabetical = 3
    case leastComments = 4
    case mostComments = 5
    case worstRating = 6
    case bestRating = 7
    case leastViews = 8
    case mostViews = 9
    case leastFollows = 10
    case mostFollows = 11
}

/// Languages available on the MangaDex website
enum Language: Int {
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
