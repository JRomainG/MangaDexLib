//
//  MDApi+Manga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 09/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Get the list of latest updated mangas
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaList(completion: @escaping (MDResultList<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getMangaList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get the list of existing tags for mangas
    /// - Parameter completion: The completion block called once the request is done
    public func getMangaTagList(completion: @escaping ([MDResult<MDTag>]?, MDApiError?) -> Void) {
        let url = MDPath.getMangaTagList()
        performBasicGetCompletion(url: url, completion: completion)
    }

    /// Get a random manga
    /// - Parameter completion: The completion block called once the request is done
    public func getRandomManga(completion: @escaping (MDResult<MDManga>?, MDApiError?) -> Void) {
        let url = MDPath.getRandomManga()
        performBasicGetCompletion(url: url, completion: completion)
    }

}
