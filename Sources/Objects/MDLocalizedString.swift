//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a string in a given language returned by MangaDex
public struct MDLocalizedString: Decodable {
    /// The locale in which this string is translated
    public let locale: Locale

    /// The content of the string
    public let value: String
}

extension MDLocalizedString {

    /// Custom `init` implementation to flatten the JSON and convert it to meaningful parameters
    public init(from decoder: Decoder) throws {
        let localIdentifier = decoder.codingPath.first!.stringValue
        locale = Locale.init(identifier: localIdentifier)
        value = try decoder.singleValueContainer().decode(String.self)
    }

}
