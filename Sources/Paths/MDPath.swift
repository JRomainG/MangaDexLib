//
//  MDPath.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The class responsible for generating URLs for calls to the website and API
public class MDPath {

    /// Build the normalized (lowercase ascii without spaces) version of the string
    ///
    /// Spaces are replaced by dashes, diacritics, special width, and case are removed.
    /// E.g. `Mÿ nâMe ís jÄço´B` becomes `my-name-is-jacob`
    static func normalize(string: String) -> String {
        let options: String.CompareOptions = [
            .diacriticInsensitive,
            .caseInsensitive,
            .widthInsensitive
        ]
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789-")
        var normalized = string.replacingOccurrences(of: " ", with: "-")
        normalized = normalized.folding(options: options, locale: .none)
        return normalized.components(separatedBy: allowed.inverted).joined(separator: "")
    }

    /// Convert the given string into its normalized version
    /// - Parameter string: The string to normalize
    /// - Parameter defaultString: The default value to return if the normalized string is empty
    /// - Returns: A normalized string
    static func getNormalizedString(from string: String?, defaultString: String = "") -> String {
        let normalized = string != nil ? normalize(string: string!) : ""
        return normalized.count > 0 ? normalized: defaultString
    }

    /// Get the value in the url for the given key, if any
    /// - Parameter key: The name of the item to look for
    /// - Parameter url: The url in which to look
    /// - Returns: The value for the key, if any
    static func getQueryItem(for key: String, in url: URL?) -> String? {
        guard url != nil else {
            return nil
        }
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
        return components?.queryItems?.first(where: { (item) -> Bool in
            return item.name == key
            })?.value
    }

    /// Build an absolute URL with the known base and the given path
    /// - Parameter path: The relative path of the resource
    /// - Returns: The MangaDex URL
    static func buildUrl(for path: Path) -> URL {
        let url = URL(string: MDApi.baseURL)!
        return url.appendingPathComponent(path.rawValue)
    }

    /// Build an absolute URL with the known base and the given `Int` parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static func buildUrl(for path: Path, with components: [Int]) -> URL {
        var url = URL(string: MDApi.baseURL)!
        url = url.appendingPathComponent(path.rawValue)
        for component in components {
            url = url.appendingPathComponent(String(component))
        }
        return url
    }

    /// Build an absolute URL with the known base and the given `String` parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static func buildUrl(for path: Path, with components: [String]) -> URL {
        var url = URL(string: MDApi.baseURL)!
        url = url.appendingPathComponent(path.rawValue)
        for component in components {
            url = url.appendingPathComponent(component)
        }
        return url
    }

    /// Build an absolute URL with the known base and the given GET parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter params: A list of items to encode in the URL
    /// - Parameter keepEmpty: Whether to keep items with a nil value
    /// - Returns: The MangaDex URL
    static func buildUrl(for path: Path, with params: [URLQueryItem], keepEmpty: Bool = true) -> URL {
        // Use URLComponents to build the string and escape the passed values
        var components = URLComponents(string: "\(MDApi.baseURL)/\(path.rawValue)")!

        // Only iterate over elements to keep non-empty one if necessary
        if keepEmpty {
            components.queryItems = params
        } else {
            components.queryItems = []
            for param in params where (param.value != nil && !param.value!.isEmpty) {
                components.queryItems?.append(param)
            }
        }

        // We manually have to escape the "+" for some reason...
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components.url!
    }

}
