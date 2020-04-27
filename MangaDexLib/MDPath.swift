//
//  MDPath.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

class MDPath {

    /// Relative paths to the pages on MangaDex
    enum Path: String {
        case listedMangas = "titles"
        case featuredMangas = "featured"
        case latestMangas = "updates"
        case searchMangas = "search"
        case randomManga = "manga"
    }

    /// Builds an absolute URL with the known base and the given path
    /// - Parameter path: The relative path of the resource
    /// - Returns: The MangaDex URL
    static private func buildUrl(for path: Path) -> URL {
        let urlString = "\(MDApi.baseURL)/\(path.rawValue)"
        return URL(string: urlString)!
    }

    /// Builds an absolute URL with the known base and the given parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static private func buildUrl(for path: Path, with components: [Int]) -> URL {
        var urlString = "\(MDApi.baseURL)/\(path.rawValue)"
        for component in components {
            urlString += "/\(component)"
        }
        return URL(string: urlString)!
    }

    /// Builds an absolute URL with the known base and the given GET parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter params: A list of items to encode in the URL
    /// - Parameter keepEmpty: Whether to keep items with a nil value
    /// - Returns: The MangaDex URL
    static private func buildUrl(for path: Path, with params: [URLQueryItem], keepEmpty: Bool = true) -> URL {
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

    /// Returns the URL to fetch the sorted list of mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Returns: The MangaDex URL
    static func listedMangas(page: Int, sort: SortOrder) -> URL {
        return buildUrl(for: .listedMangas, with: [sort.rawValue, page])
    }

    /// Returns the URL to fetch the featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    static func featuredMangas(page: Int) -> URL {
        return buildUrl(for: .featuredMangas, with: [page])
    }

    /// Returns the URL to fetch the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    static func latestMangas(page: Int) -> URL {
        return buildUrl(for: .latestMangas, with: [page])
    }

    /// Returns the URL for a random manga
    static func randomManga() -> URL {
        return buildUrl(for: .randomManga)
    }

    /// Returns the URL for performing a search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Returns: The MangaDex URL
    static func search(_ search: MDSearch) -> URL {
        // The include and exclude tags are actually bundled in the same list,
        // Exclude tags are simply preceded by a "-". First build each string
        let includeTags = search.includeTags.map { String($0) }.joined(separator: ",")
        let excludeTags = search.excludeTags.map { String(-$0) }.joined(separator: ",")

        // Then, join both strings together in a nice way
        let tags: String?
        if includeTags.count > 0 && excludeTags.count > 0 {
            tags = "\(includeTags),\(excludeTags)"
        } else if includeTags.count > 0 {
            tags = includeTags
        } else if excludeTags.count > 0 {
            tags = excludeTags
        } else {
            tags = nil
        }

        // Build the other lists of ids, which are simpler
        let demos = search.demographics.map { String($0.rawValue) }.joined(separator: ",")
        let statuses = search.publicationStatuses.map { String($0.rawValue) }.joined(separator: ",")

        // The language is an int, but has to be converted to a string
        let lang: String?
        if search.originalLanguage != nil {
            lang = String(search.originalLanguage!.rawValue)
        } else {
            lang = nil
        }

        // Build the list of params using URLQueryItem, as they are automatically escaped
        let params: [URLQueryItem] = [
            URLQueryItem(name: MDSearch.Parameter.title.rawValue, value: search.title),
            URLQueryItem(name: MDSearch.Parameter.author.rawValue, value: search.author),
            URLQueryItem(name: MDSearch.Parameter.artist.rawValue, value: search.artist),
            URLQueryItem(name: MDSearch.Parameter.originalLanguage.rawValue, value: lang),
            URLQueryItem(name: MDSearch.Parameter.demographics.rawValue, value: demos),
            URLQueryItem(name: MDSearch.Parameter.publicationStatuses.rawValue, value: statuses),
            URLQueryItem(name: MDSearch.Parameter.tags.rawValue, value: tags),
            URLQueryItem(name: MDSearch.Parameter.includeTagsMode.rawValue, value: search.includeTagsMode.rawValue),
            URLQueryItem(name: MDSearch.Parameter.excludeTagsMode.rawValue, value: search.excludeTagsMode.rawValue)
        ]
        return MDPath.buildUrl(for: .searchMangas, with: params, keepEmpty: false)
    }

}
