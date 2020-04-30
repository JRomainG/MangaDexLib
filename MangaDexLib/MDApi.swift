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
    internal let requestHandler = MDRequestHandler()

    /// Instance of `MDParser` used to parse the results of the requests
    internal let parser = MDParser()

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

// MARK: - MDApi Generic Helper Methods

extension MDApi {

    /// Wrapper around MDRequestHandler's get method
    /// - Parameter url: The URL to fetch
    /// - Parameter type: The type of response that is expected
    /// - Parameter errorCompletion: The user-provided completion that will be called in case of an error
    /// - Parameter success: The internal completion called in the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    internal func performGet(url: URL,
                             type: MDResponse.ResponseType,
                             errorCompletion: @escaping MDCompletion,
                             success: @escaping MDCompletion) {
        requestHandler.get(url: url) { (content, requestError) in
            // Build a response object for the completion
            let response = MDResponse(type: type, url: url, rawValue: content, error: requestError)
            guard requestError == nil, content != nil else {
                errorCompletion(response)
                return
            }
            success(response)
        }
    }

    /// Wrapper around MDRequestHandler's post method
    /// - Parameter url: The URL to load
    /// - Parameter body: The content of the request
    /// - Parameter type: The type of response that is expected
    /// - Parameter errorCompletion: The user-provided completion that will be called in case of an error
    /// - Parameter success: The internal completion called in the requests succeeds
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    internal func performPost(url: URL,
                              body: [String: LosslessStringConvertible],
                              encoding: MDRequestHandler.BodyEncoding = .multipart,
                              type: MDResponse.ResponseType,
                              errorCompletion: @escaping MDCompletion,
                              success: @escaping MDCompletion) {
        requestHandler.post(url: url, content: body, encoding: encoding) { (content, requestError) in
            // Build a response object for the completion
            let response = MDResponse(type: type, url: url, rawValue: content, error: requestError)
            guard requestError == nil, content != nil else {
                errorCompletion(response)
                return
            }
            success(response)
        }
    }

}

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
    func performSearch(_ search: MDSearch, completion: @escaping MDCompletion) {
        let url = MDPath.search(search)
        getMangas(from: url, completion: completion)
    }

}

// MARK: - MDApi JSON Requests

extension MDApi {

    /// Fetches detailed information about the manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter completion: The callback at the end of the request
    func getMangaInfo(mangaId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.mangaInfo(mangaId: mangaId)
        self.performGet(url: url, type: .mangaInfo, errorCompletion: completion) { (response) in
            do {
                let json = response.rawValue!
                response.manga = try self.parser.getMangaApiInfo(from: json, mangaId: mangaId)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

    /// Fetch detailed information about the chapter
    /// - Parameter chapterId: The identifier of the chapter
    /// - Parameter completion: The callback at the end of the request
    func getChapterInfo(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterInfo(chapterId: chapterId, server: server)
        self.performGet(url: url, type: .chapterInfo, errorCompletion: completion) { (response) in
            do {
                let json = response.rawValue!
                response.chapter = try self.parser.getChapterApiInfo(from: json)
                completion(response)
            } catch {
                response.error = error
                completion(response)
            }
        }
    }

}

// MARK: - MDApi Auth

extension MDApi {

    /// Perform a POST request with the given credentials to login
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    ///
    /// `info.username` and `info.password` must not be filled in
    private func performAuth(with info: MDAuth, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction(javascriptEnabled: false)
        let username = info.username ?? ""
        let password = info.password ?? ""
        let body: [String: LosslessStringConvertible] = [
            MDRequestHandler.AuthField.username.rawValue: username,
            MDRequestHandler.AuthField.password.rawValue: password,
            MDRequestHandler.AuthField.twoFactor.rawValue: "",
            MDRequestHandler.AuthField.remember.rawValue: info.remember ? "1" : "0"
        ]
        performPost(url: url,
                    body: body,
                    encoding: .urlencoded,
                    type: .login,
                    errorCompletion: completion) { (response) in
                        // Save the cookie in the response so it's accessible from outside the API
                        response.token = self.requestHandler.getCookie(type: .authToken)
                        completion(response)
        }
    }

    /// Set the token in the `MDRequestHandler` cookies so the user is authenticated for
    /// the next requests
    ///
    /// TODO: Check if token is no longer valid (user isn't logged in after setting the cookie)
    private func setAuthToken(_ token: String?, completion: @escaping MDCompletion) {
        let url = MDPath.loginAction()
        let response = MDResponse(type: .login, url: url, rawValue: "", error: nil)

        if token == nil {
            // TODO: Error
            completion(response)
        } else {
            requestHandler.setCookie(type: .authToken, value: token!, sessionOnly: false, secure: true)
            response.token = token
            completion(response)
        }
    }

    /// Attempt to login with the given credentials
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    func login(with info: MDAuth, completion: @escaping MDCompletion) {
        switch info.type {
        case .regular:
            performAuth(with: info, completion: completion)
        case .token:
            setAuthToken(info.token, completion: completion)
        default:
            // TODO: Raise unimplemented error
            break
        }
    }

    /// Attempt to login with the given credentials
    /// - Parameter info: The authentication credentials to use
    /// - Parameter completion: The callback at the end of the request
    func logout(completion: @escaping MDCompletion) {
        let url = MDPath.logoutAction()
        performPost(url: url, body: [:], type: .logout, errorCompletion: completion, success: completion)
    }

    /// Checks whether the user has an auth token set
    ///
    /// This does not check whether the token is valid or not
    func isLoggedIn() -> Bool {
        return requestHandler.getCookie(type: .authToken) != nil
    }

}
