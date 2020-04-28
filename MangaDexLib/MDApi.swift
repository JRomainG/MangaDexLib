//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

class MDApi: NSObject {

    /// URL for the MangaDex website
    static let baseURL = "https://mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the lib
    static let defaultUserAgent = "MangaDexLib"

    /// Cookie saving the user's choice regarding the display of rated manga.
    /// Cookie key: `mangadex_h_toggle`
    enum RatedFilter: Int {
        case noR18 = 0
        case all = 1
        case onlyR18 = 2
    }

    /// Available MangaDex servers to fetch chapter pages from
    enum Server: String {
        case automatic = "0"
        case naEu1 = "na"
        case naEu2 = "na2"
        // The following options are currently disabled on the website
        //case europe = "eu"
        //case europe2 = "eu2"
        //case restOfTheWorld = "row"
    }

    /// The server from which to server manga pages
    let server: Server = .automatic

    /// Instance of `MDRequestHandler` used to perform all requests
    let requestHandler = MDRequestHandler()

    /// TypeAlias for completion blocks
    typealias MDCompletion = (String?, Error?) -> Void

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
