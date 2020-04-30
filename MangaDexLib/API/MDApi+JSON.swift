//
//  MDApi+JSON.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

// MARK: - MDApi JSON Requests

extension MDApi {

    /// Fetches detailed information about the manga
    /// - Parameter mangaId: The identifier of the manga
    /// - Parameter completion: The callback at the end of the request
    public func getMangaInfo(mangaId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.mangaInfo(mangaId: mangaId)
        self.performGet(url: url, type: .mangaInfo, onError: completion) { (response) in
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
    public func getChapterInfo(chapterId: Int, completion: @escaping MDCompletion) {
        let url = MDPath.chapterInfo(chapterId: chapterId, server: server)
        self.performGet(url: url, type: .chapterInfo, onError: completion) { (response) in
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
