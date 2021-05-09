//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a string in a given language returned by MangaDex
public struct MDLocalizedString {

    /// The available translated strings
    public let translations: [Locale: String]

}

extension MDLocalizedString: Decodable {

    /// Dynamic coding keys to flatten the dict returned by the MangaDex API
    private struct CodingKeys: CodingKey {

        // The API returns a string-keyed dictionary, so all keys will be strings
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Return nil since we know keys are strings
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }

    }

    /// Custom `init` implementation to flatten the JSON and convert it to meaningful parameters
    public init(from decoder: Decoder) throws {
        // Start by decoding all the keys of the dictionary, aka all the available language codes
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Now, for each language, get the associated string and convert the language code to a Locale object
        var strings: [Locale: String] = [:]
        for langCode in container.allKeys {
            let locale = Locale.init(identifier: langCode.stringValue)
            let translation = try container.decode(String.self, forKey: langCode)
            strings[locale] = translation
        }

        translations = strings
    }

}

extension MDLocalizedString: Encodable {

    /// Custom `encode` implementation to convert our attributes to the ones expected by the MangaDex API
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (locale, string) in translations {
            try container.encode(string, forKey: CodingKeys.init(stringValue: locale.identifier)!)
        }
    }

}
