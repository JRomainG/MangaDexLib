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
        self.performGet(url: url, type: .mangaList, onError: completion) { (response) in
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
    private func getMangaDetails(from url: URL, completion: @escaping MDCompletion) {
        self.performGet(url: url, type: .mangaInfo, onError: completion) { (response) in
            do {
                let html = response.rawValue!
                response.manga = try self.parser.getMangaDetails(from: html)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Common method for getting a list of chaoters from a URL
    /// - Parameter url: The URL used to build the request
    /// - Parameter completion: The callback at the end of the request
    private func getChapters(from url: URL, completion: @escaping MDCompletion) {
        self.performGet(url: url, type: .chapterList, onError: completion) { (response) in
            do {
                let html = response.rawValue!
                response.chapters = try self.parser.getChapters(from: html)
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
        self.performGet(url: url, type: .commentList, onError: completion) { (response) in
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

    /// Fetch MangaDex's homepage, as well as a potential announcement and alerts
    /// - Parameter completion: The callback at the end of the request
    ///
    /// It is good practice to start wih this request, to be aware of announcements,
    /// alerts and eventually maintenance.
    /// It also allows cookies to be set so other requests aren't rejected
    public func getHomepage(completion: @escaping MDCompletion) {
        let url = URL(string: MDApi.baseURL)!
        performGet(url: url, type: .homepage, onError: completion) { (response) in
            let html = response.rawValue!
            response.announcement = self.parser.getAnnouncement(from: html)
            response.alerts = self.parser.getAlerts(from: html)
            completion(response)
        }
    }

    /// Fetch the information of a random
    /// - Parameter completion: The callback at the end of the request
    public func getRandomManga(completion: @escaping MDCompletion) {
        let url = MDPath.randomManga()
        getMangaDetails(from: url, completion: completion)
    }

    /// Fetch a list of sorted mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter sort: The order in which to sort results
    /// - Parameter completion: The callback at the end of the request
    public func getListedMangas(page: Int, sort: MDSortOrder, completion: @escaping MDCompletion) {
        let url = MDPath.listedMangas(page: page, sort: sort)
        getMangas(from: url, completion: completion)
    }

    /// Fetch the list of featured mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    public func getFeaturedMangas(completion: @escaping MDCompletion) {
        let url = MDPath.featuredMangas()
        getMangas(from: url, completion: completion)
    }

    /// Fetch the latest updated mangas
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    public func getLatestMangas(page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.latestMangas(page: page)
        getMangas(from: url, completion: completion)
    }

    /// Fetch the latest updated mangas followed by the user
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter status: The user-defined status of the mangas to show (other than `.unfollowed`)
    /// - Parameter completion: The callback at the end of the request
    public func getLatestFollowedMangas(page: Int, status: MDReadingStatus, completion: @escaping MDCompletion) {
        let url = MDPath.latestFollowed(page: page, type: .manga, status: status)
        checkLoggedIn(url: url, onError: completion) {
            self.getMangas(from: url, completion: completion)
        }
    }

    /// Fetch the list of mangas in the user's history
    /// - Parameter completion: The callback at the end of the request
    ///
    /// - Note: Only the last 10 read titles are listed
    public func getHistory(completion: @escaping MDCompletion) {
        let url = MDPath.history()
        checkLoggedIn(url: url, onError: completion) {
            self.getMangas(from: url, completion: completion)
        }
    }

    /// Fetch a manga's latest comments
    /// - Parameter mangaId: The manga for which to fetch comments
    /// - Parameter title: The title of the manga (can be nil)
    /// - Parameter completion: The callback at the end of the request
    ///
    /// To get the full list of comments, use `getThread` with any comment's `threadId`.
    /// Only the `mangaId` property is required to be non-nil, but also having `title` is better
    public func getMangaComments(mangaId: Int, title: String?, completion: @escaping MDCompletion) {
        let url = MDPath.mangaComments(mangaId: mangaId, mangaTitle: title)
        getComments(from: url, completion: completion)
    }

    /// Fetch a manga's chapters, in reverse chronological order
    /// - Parameter mangaId: The manga for which to fetch comments
    /// - Parameter title: The title of the manga (can be nil)
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    ///
    /// To get the full list of comments, use `getThread` with any comment's `threadId`.
    /// Only the `mangaId` property is required to be non-nil, but also having `title` is better
    public func getMangaChapters(mangaId: Int, title: String?, page: Int, comletion: @escaping MDCompletion) {
        let url = MDPath.mangaChapters(mangaId: mangaId, mangaTitle: title, page: page)
        getChapters(from: url, completion: comletion)
    }

    /// Fetch the information of a random
    /// - Parameter mangaId: The manga for which to fetch comments
    /// - Parameter title: The title of the manga (can be nil)
    /// - Parameter completion: The callback at the end of the request
    ///
    /// Contrary to `getMangaInfo`, this call returns information relating to the logged in user,
    /// notably a manga's `MDReadingStatus`
    public func getMangaDetails(mangaId: Int, title: String?, completion: @escaping MDCompletion) {
        let url = MDPath.mangaDetails(mangaId: mangaId, mangaTitle: title)
        getMangaDetails(from: url, completion: completion)
    }

    /// Fetch the latest updated chapters for mangas followed by the user
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter status: The user-defined status of the mangas for which to show chapters (other than `.unfollowed`)
    /// - Parameter completion: The callback at the end of the request
    public func getLatestFollowedChapters(page: Int, status: MDReadingStatus, completion: @escaping MDCompletion) {
        let url = MDPath.latestFollowed(page: page, type: .chapters, status: status)
        checkLoggedIn(url: url, onError: completion) {
            self.getChapters(from: url, completion: completion)
        }
    }

    /// Fetch a chapter's latest comments
    /// - Parameter chapterId: The ID of the chapter for which to fetch comments
    /// - Parameter completion: The callback at the end of the request
    ///
    /// To get the full list of comments, use `getThread` with any comment's `threadId`.
    /// Only the `chapterId` property is required to be non-nil
    public func getChapterComments(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterComments(chapterId: chapterId)
        getComments(from: url, completion: completion)
    }

    /// Fetch a thread's comments
    /// - Parameter threadId: The thread for which to fetch comments
    /// - Parameter page: The index of the page to load (starting at 1)
    /// - Parameter completion: The callback at the end of the request
    public func getThread(threadId: Int, page: Int, completion: @escaping MDCompletion) {
        let url = MDPath.thread(threadId: threadId, page: page)
        getComments(from: url, completion: completion)
    }

    /// Fetch a groups's info
    /// - Parameter groupId: The id of the group for which to fetch the info
    /// - Parameter completion: The callback at the end of the request
    ///
    /// While this method should return a pretty
    public func getGroupInfo(groupId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.groupInfo(groupId: groupId)
        self.performGet(url: url, type: .groupInfo, onError: completion) { (response) in
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

    /// Fetch a user's MDList
    /// - Parameter userId: The id of the user for which to fetch the MDList
    /// - Parameter status: The user-defined status of the mangas to show (other than `.unfollowed`)
    /// - Parameter completion: The callback at the end of the request
    ///
    /// While this method should return a pretty
    public func getMdList(userId: Int, status: MDReadingStatus, completion: @escaping MDCompletion) {
        let url = MDPath.mdList(userId: userId, status: status)
        getMangas(from: url, completion: completion)
    }

    /// Fetch the results of the search
    /// - Parameter search: An `MDSearch` instance representing the query
    /// - Parameter completion: The callback at the end of the request
    ///
    /// - Note: Only logged-in users can search
    public func performSearch(_ search: MDSearch, completion: @escaping MDCompletion) {
        let url = MDPath.search(search)
        checkLoggedIn(url: url, onError: completion) {
            self.getMangas(from: url, completion: completion)
        }
    }

}
