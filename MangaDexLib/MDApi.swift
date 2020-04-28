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

    /// TypeAlias for completion blocks
    typealias MDCompletion = (String?, Error?) -> Void

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

    /// Fetches the html homepage of MangaDex
    /// - Parameter completion: The callback at the end of the request
    func getHomepage(completion: @escaping MDCompletion) {
        let url = URL(string: MDApi.baseURL)!
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the html page containing the sorted list of mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Parameter completion: The callback at the end of the request
    func getListedMangas(page: Int, sort: MDSortOrder, completion: @escaping MDCompletion) {
        let url = MDPath.listedMangas(page: page, sort: sort)
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the html page containing the featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getFeaturedMangas(page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.featuredMangas(page: page)
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the html page containing the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getLatestMangas(page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.latestMangas(page: page)
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the html page containing information about a random manga
    /// - Parameter completion: The callback at the end of the request
    func getRandomManga(completion: @escaping MDCompletion) {
        let url = MDPath.randomManga()
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the html page containing the result of the search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Parameter completion: The callback at the end of the request
    func performSearch(_ search: MDSearch, completion: @escaping MDCompletion) {
        let url = MDPath.search(search)
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the json string containing the information about the manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter completion: The callback at the end of the request
    func getMangaInfo(mangaId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.mangaInfo(mangaId: mangaId)
        requestHandler.get(url: url, completion: completion)
    }

    /// Fetches the json string containing the information about the chapter
    /// - Parameter chapterId: The identifier of the chapter
    /// - Parameter completion: The callback at the end of the request
    func getChapterInfo(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterInfo(chapterId: chapterId, server: server)
        requestHandler.get(url: url, completion: completion)
    }

}
