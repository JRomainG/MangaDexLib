//
//  MDApi+HTML.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

// MARK: - MDApi HTML Requests

extension MDApi {

    /// Common method for getting a list of mangas from a URL
    /// - Parameter url: The URL used to build the request
    /// - Parameter completion: The callback at the end of the request
    private func getMangas(from url: URL, completion: @escaping MDCompletion) {
        self.performGet(url: url, type: .mangaList, errorCompletion: completion) { (response) in
            do {
                let html = response.rawValue!
                response.mangas = try self.parseMangaHtmlList(html)
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

    /// Convenience method to parse a manga's detail page
    /// - Parameter url: The URL used to build the request
    /// - Parameter completion: The callback at the end of the request
    private func getMangaInfo(from url: URL, completion: @escaping MDCompletion) {
        self.performGet(url: url, type: .mangaInfo, errorCompletion: completion) { (response) in
            do {
                let html = response.rawValue!
                response.manga = try self.parser.getMangaInfo(from: html)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Common method for getting a list of comments from a URL
    /// - Parameter url: The URL used to build the request
    /// - Parameter completion: The callback at the end of the request
    private func getComments(from url: URL, completion: @escaping MDCompletion) {
        self.performGet(url: url, type: .commentList, errorCompletion: completion) { (response) in
            do {
                let html = response.rawValue!
                response.comments = try self.parser.getComments(from: html)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Fetch the information of a random
    /// - Parameter completion: The callback at the end of the request
    func getRandomManga(completion: @escaping MDCompletion) {
        let url = MDPath.randomManga()
        getMangaInfo(from: url, completion: completion)
    }

    /// Fetch a list of sorted mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Parameter completion: The callback at the end of the request
    func getListedMangas(page: Int, sort: MDSortOrder, completion: @escaping MDCompletion) {
        let url = MDPath.listedMangas(page: page, sort: sort)
        getMangas(from: url, completion: completion)
    }

    /// Fetch the list of featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getFeaturedMangas(completion: @escaping MDCompletion) {
        let url = MDPath.featuredMangas()
        getMangas(from: url, completion: completion)
    }

    /// Fetch the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getLatestMangas(page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.latestMangas(page: page)
        getMangas(from: url, completion: completion)
    }

    /// Fetch a manga's latest comments
    /// - Parameter manga: The manga for which to fetch comments
    /// - Parameter title: The title of the manga (can be nil)
    /// - Parameter completion: The callback at the end of the request
    ///
    /// To get the full list of comments, use `getThread` with any comment's `threadId`.
    /// Only the `mangaId` property is required to be non-nil, but also having `title` is better
    func getMangaComments(mangaId: Int, title: String?, completion: @escaping MDCompletion) {
        let url = MDPath.mangaComments(mangaId: mangaId, mangaTitle: title)
        getComments(from: url, completion: completion)
    }

    /// Fetch a chapter's latest comments
    /// - Parameter chapterId: The ID of the chapter for which to fetch comments
    /// - Parameter completion: The callback at the end of the request
    ///
    /// To get the full list of comments, use `getThread` with any comment's `threadId`.
    /// Only the `chapterId` property is required to be non-nil
    func getChapterComments(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterComments(chapterId: chapterId)
        getComments(from: url, completion: completion)
    }

    /// Fetch a thread's comments
    /// - Parameter threadId: The thread for which to fetch comments
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    func getThread(threadId: Int, page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.thread(threadId: threadId, page: page)
        getComments(from: url, completion: completion)
    }

    /// Fetch a groups's info
    /// - Parameter groupId: The id of the group for which to fetch the info
    /// - Parameter completion: The callback at the end of the request
    ///
    /// While this method should return a pretty
    func getGroupInfo(groupId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.groupInfo(groupId: groupId)
        self.performGet(url: url, type: .groupInfo, errorCompletion: completion) { (response) in
            do {
                let html = response.rawValue!
                response.group = try self.parser.getGroupInfo(from: html)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Fetch the results of the search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Parameter completion: The callback at the end of the request
    ///
    /// - Note: Only logged-in users can search
    func performSearch(_ search: MDSearch, completion: @escaping MDCompletion) {
        let url = MDPath.search(search)
        guard isLoggedIn() else {
            let response = MDResponse(type: .generic, url: url, error: MDError.loginRequired)
            completion(response)
            return
        }
        getMangas(from: url, completion: completion)
    }

}
