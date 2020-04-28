//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The main MangaDex API class, which should be used to access the framework's capabilities
class MDApi: NSObject {

    /// URL for the MangaDex website
    static let baseURL = "https://mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    static let defaultUserAgent = "MangaDexLib"

    /// The server from which to server manga pages
    private(set) var server: MDServer = .automatic

    /// Whether to show rated manga of not
    private(set) var ratedFilter: MDRatedFilter = .noR18

    /// Instance of `MDRequestHandler` used to perform all requests
    let requestHandler = MDRequestHandler()

    /// Instance of `MDParser` used to parse the results of the requests
    let parser = MDParser()

    /// TypeAlias for completion blocks
    typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the rated filter cookie
    func setRatedFilter(_ filter: MDRatedFilter) {
        self.ratedFilter = filter
        requestHandler.setCookie(type: .ratedFilter, value: String(filter.rawValue))
    }

    /// Setter for the server to use when fetching chapter pages
    func setServer(_ server: MDServer) {
        self.server = server
    }

    /// Setter for the User-Agent to use for requests
    func setUserAgent(_ userAgent: String) {
        requestHandler.setUserAgent(userAgent)
    }

}

// MARK: - MDApi HTML Requests

extension MDApi {

    /// Common method for getting a list of mangas from a URL
    /// - Parameter url: The URL used to build the request
    /// - Parameter completion: The callback at the end of the request
    private func getMangas(from url: URL, completion: @escaping MDCompletion) {
        requestHandler.get(url: url) { (content, requestError) in
            // Build a response object for the completion
            let response = MDResponse(type: .mangaList, url: url, rawValue: content, error: requestError)
            guard requestError == nil, let html = content else {
                completion(response)
                return
            }

            // Try to parse the content
            do {
                let mangas = try self.parseMangaHtmlList(html)
                response.mangas = mangas
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Convenience method to call the parser and extract mangas from and html string
    /// - Parameter html: The string to parse
    /// - Returns: A list of mangas
    ///
    /// The mangas will either have titles and ids, or only ids (if the first method fails).
    /// To get more info, a request `getMangaInfo` request must be made
    private func parseMangaHtmlList(_ html: String) throws -> [MDManga] {
        // Try to extract mangas with their titles and IDs
        let mangas = try self.parser.getMangas(from: html)
        if mangas.count > 0 {
            return mangas
        }

        // Use the parser's fallback if no manga was found
        return try self.parser.getMangaIds(from: html)
    }

    /// Fetches the html page containing information about a random manga
    /// - Parameter completion: The callback at the end of the request
    func getRandomManga(completion: @escaping MDCompletion) {
        let url = MDPath.randomManga()
        requestHandler.get(url: url) { (content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: .mangaInfo, url: url, rawValue: content, error: error)

            do {
                response.manga = try self.parser.getMangaInfo(from: content!)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Fetches the html page containing the sorted list of mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Parameter completion: The callback at the end of the request
    func getListedMangas(page: Int, sort: MDSortOrder, completion: @escaping MDCompletion) {
        let url = MDPath.listedMangas(page: page, sort: sort)
        getMangas(from: url, completion: completion)
    }

    /// Fetches the html page containing the featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getFeaturedMangas(completion: @escaping MDCompletion) {
        let url = MDPath.featuredMangas()
        getMangas(from: url, completion: completion)
    }

    /// Fetches the html page containing the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getLatestMangas(page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.latestMangas(page: page)
        getMangas(from: url, completion: completion)
    }

    /// Fetches the html page containing the result of the search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Parameter completion: The callback at the end of the request
    func performSearch(_ search: MDSearch, completion: @escaping MDCompletion) {
        let url = MDPath.search(search)
        getMangas(from: url, completion: completion)
    }

}

// MARK: - MDApi JSON Requests

extension MDApi {

    /// Fetches the json string containing the information about the manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter completion: The callback at the end of the request
    func getMangaInfo(mangaId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.mangaInfo(mangaId: mangaId)
        requestHandler.get(url: url) { (content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: .mangaList, url: url, rawValue: content, error: error)
            completion(response)
        }
    }

    /// Fetches the json string containing the information about the chapter
    /// - Parameter chapterId: The identifier of the chapter
    /// - Parameter completion: The callback at the end of the request
    func getChapterInfo(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterInfo(chapterId: chapterId, server: server)
        requestHandler.get(url: url) { (content, error) in
            // Build a response object for the completion
            let response = MDResponse(type: .mangaList, url: url, rawValue: content, error: error)
            completion(response)
        }
    }

}
