//
//  MDPath.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The class responsible for generating URLs for calls to the website and API
class MDPath {

    /// Relative paths to the pages on MangaDex
    enum Path: String {
        case listedMangas = "titles"
        case featuredMangas = "featured"
        case latestMangas = "updates"
        case searchMangas = "search"
        case randomManga = "manga"
        case mangaPage = "title"
        case chapterPage = "chapter"
        case groupPage = "group"
        case comments = "comments"
        case thread = "thread"
        case login = "login"
        case logout = "logout"
        case ajax = "ajax/actions.ajax.php"
        case api = "api"
    }

    /// Type of parameter used in a search request
    enum SearchParam: String {
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

    /// Type of parameter used for Ajax post requests
    ///
    /// These parameters are the ones encoded in the URL to build the path
    enum AjaxParams: String {
        case function = "function"
        case noJS = "nojs"
    }

    /// Type of parameter used during api calls
    enum ApiParam: String {
        case id = "id"
        case server = "server"
        case type = "type"
    }

    /// Type of content to fetch when querying the API
    enum ApiContent: String {
        case manga = "manga"
        case chapter = "chapter"
    }

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
        var allowed = CharacterSet.alphanumerics
        allowed.insert("-")
        var normalized = string.replacingOccurrences(of: " ", with: "-")
        normalized = normalized.folding(options: options, locale: .none)
        return normalized.components(separatedBy: allowed.inverted).joined(separator: "")
    }

    /// Build an absolute URL with the known base and the given path
    /// - Parameter path: The relative path of the resource
    /// - Returns: The MangaDex URL
    static private func buildUrl(for path: Path) -> URL {
        let url = URL(string: MDApi.baseURL)!
        return url.appendingPathComponent(path.rawValue)
    }

    /// Build an absolute URL with the known base and the given `Int` parameters
    /// - Parameter path: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static private func buildUrl(for path: Path, with components: [Int]) -> URL {
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
    static private func buildUrl(for path: Path, with components: [String]) -> URL {
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

    /// Build the URL to fetch the sorted list of mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Returns: The MangaDex URL
    static func listedMangas(page: Int, sort: MDSortOrder) -> URL {
        return buildUrl(for: .listedMangas, with: [sort.rawValue, page])
    }

    /// Build the URL to fetch the featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    static func featuredMangas() -> URL {
        return buildUrl(for: .featuredMangas)
    }

    /// Build the URL to fetch the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    static func latestMangas(page: Int) -> URL {
        return buildUrl(for: .latestMangas, with: [page])
    }

    /// Build the URL to get a random manga
    static func randomManga() -> URL {
        return buildUrl(for: .randomManga)
    }

    /// Build the URL for performing a search
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
        let params = [
            URLQueryItem(name: SearchParam.title.rawValue, value: search.title),
            URLQueryItem(name: SearchParam.author.rawValue, value: search.author),
            URLQueryItem(name: SearchParam.artist.rawValue, value: search.artist),
            URLQueryItem(name: SearchParam.originalLanguage.rawValue, value: lang),
            URLQueryItem(name: SearchParam.demographics.rawValue, value: demos),
            URLQueryItem(name: SearchParam.publicationStatuses.rawValue, value: statuses),
            URLQueryItem(name: SearchParam.tags.rawValue, value: tags),
            URLQueryItem(name: SearchParam.includeTagsMode.rawValue, value: search.includeTagsMode.rawValue),
            URLQueryItem(name: SearchParam.excludeTagsMode.rawValue, value: search.excludeTagsMode.rawValue)
        ]
        return MDPath.buildUrl(for: .searchMangas, with: params, keepEmpty: false)
    }

    /// Build the URL to fetch information about a given manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Returns: The MangaDex URL
    static func mangaInfo(mangaId: Int) -> URL {
        let params = [
            URLQueryItem(name: ApiParam.id.rawValue, value: String(mangaId)),
            URLQueryItem(name: ApiParam.type.rawValue, value: ApiContent.manga.rawValue)
        ]
        return MDPath.buildUrl(for: .api, with: params)
    }

    /// Build the URL to fetch a given manga's comments
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter mangaTitle: The title of the manga (not strictly necessary)
    /// - Returns: The MangaDex URL
    static func mangaComments(mangaId: Int, mangaTitle: String?) -> URL {
        // The title doesn't really matter, but let's try to make it nice either way
        let normalizedTitle: String
        if let title = mangaTitle {
            normalizedTitle = normalize(string: title)
        } else {
            normalizedTitle = MDApi.defaultUserAgent
        }

        let components: [String] = [String(mangaId), normalizedTitle, Path.comments.rawValue]
        return buildUrl(for: .mangaPage, with: components)
    }

    /// Build the URL to fetch information about a given chapter
    /// - Parameter chapterId: The identifier of the chapter
    /// - Parameter server: The server from which to load images
    /// - Returns: The MangaDex URL
    static func chapterInfo(chapterId: Int, server: MDServer) -> URL {
        let params = [
            URLQueryItem(name: ApiParam.id.rawValue, value: String(chapterId)),
            URLQueryItem(name: ApiParam.server.rawValue, value: server.rawValue),
            URLQueryItem(name: ApiParam.type.rawValue, value: ApiContent.chapter.rawValue)
        ]

        // When the server is set to automatic, its value is ""
        // and we don't want to send it to the API, so set keepEmpty to false
        return MDPath.buildUrl(for: .api, with: params, keepEmpty: false)
    }

    /// Build the URL to the given page's image
    /// - Parameter server: The base URL for the server
    /// - Parameter hash: The chapter's hash
    /// - Parameter page: The page's file name
    /// - Returns: The image's URL
    static func chapterPage(server: String, hash: String, page: String) -> URL {
        var url = URL(string: server)!
        url = url.appendingPathComponent(hash)
        return url.appendingPathComponent(page)
    }

    /// Build the URL to fetch a given chapter's comments
    /// - Parameter chapterId: The identifier of the chapter
    /// - Returns: The MangaDex URL
    static func chapterComments(chapterId: Int) -> URL {
        let components: [String] = [String(chapterId), Path.comments.rawValue]
        return buildUrl(for: .chapterPage, with: components)
    }

    /// Build the URL to fetch a thread's content
    /// - Parameter threadId: The identifier of the thread
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Returns: The MangaDex URL
    ///
    /// A thread represents a full chain of comments in chronological order.
    /// `mangaComments` and `chapterComments` are only URLs to the page with
    /// the latest comments
    static func thread(threadId: Int, page: Int) -> URL {
        return buildUrl(for: .thread, with: [threadId, page])
    }

    /// Build the URL to fetch information about a given group
    /// - Parameter groupId: The identifier of the group
    /// - Returns: The MangaDex URL
    static func groupInfo(groupId: Int) -> URL {
        return buildUrl(for: .groupPage, with: [groupId])
    }

    /// Build the URL to an external resource
    /// - Parameter resource: The type of external website
    /// - Parameter path: The ID or absolute URL for the resource
    /// - Returns: The external URL
    static func externalResource(resource: MDResource, path: String) -> URL? {
        // Handle cases where the resource is only a relative URL, which means the resource's
        // raw value contains the base URL for the resource
        var absoluteURL: String
        if let baseURL = resource.baseURL {
            // Can't use "appendingPathComponent" as URLs may expect a get parameter
            // Instead, just append the string to the base URL
            guard let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return nil
            }
            absoluteURL = baseURL + escapedPath
        } else {
            absoluteURL = path
        }
        return URL(string: absoluteURL)
    }

    /// Build the URL used to log in
    /// - Parameter javascriptEnabled: Whether javascript should be marked as disabled or not
    /// - Returns: The ajax URL
    static func loginAction(javascriptEnabled: Bool = true) -> URL {
        let params = [
            URLQueryItem(name: AjaxParams.function.rawValue, value: Path.login.rawValue),
            URLQueryItem(name: AjaxParams.noJS.rawValue, value: javascriptEnabled ? nil : "1")
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

    /// Build the URL used to log out
    /// - Parameter javascriptEnabled: Whether javascript should be marked as disabled or not
    /// - Returns: The ajax URL
    static func logoutAction(javascriptEnabled: Bool = true) -> URL {
        let params = [
            URLQueryItem(name: AjaxParams.function.rawValue, value: Path.logout.rawValue),
            URLQueryItem(name: AjaxParams.noJS.rawValue, value: javascriptEnabled ? nil : "1")
        ]
        return MDPath.buildUrl(for: .ajax, with: params, keepEmpty: false)
    }

}
