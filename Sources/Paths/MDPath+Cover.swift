//
//  MDPath+Cover.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 05/06/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of covers
    /// - Parameter filter: The filter to apply
    /// - Returns: The MangaDex URL
    static func getCoverList(filter: MDCoverFilter? = nil) -> URL {
        let params = filter?.getParameters() ?? []
        return buildUrl(for: .cover, params: params)
    }

    /// Build the URL to view the specified cover's information
    /// - Parameter coverId: The id of the cover
    /// - Returns: The MangaDex URL
    static func viewCover(coverId: String) -> URL {
        return buildUrl(for: .cover, with: [coverId])
    }

    /// Build the URL to upload a new cover for the specified manga
    /// - Parameter mangaId: The id of the manga to which this cover belongs
    /// - Returns: The MangaDex URL
    static func uploadCover(for mangaId: String) -> URL {
        return buildUrl(for: .cover, with: [mangaId])
    }

    /// Build the URL to update the specified cover's information
    /// - Parameter coverId: The id of the cover
    /// - Returns: The MangaDex URL
    static func updateCover(coverId: String) -> URL {
        return buildUrl(for: .cover, with: [coverId])
    }

    /// Build the URL to delete the specified cover
    /// - Parameter coverId: The id of the cover
    /// - Returns: The MangaDex URL
    static func deleteCover(coverId: String) -> URL {
        return buildUrl(for: .cover, with: [coverId])
    }

    /// Build the URL to get a cover's image
    /// - Parameter mangaId: The id of the manga to which this cover belongs
    /// - Parameter fileName: The cover's file name
    /// - Parameter size: The cover size to use
    /// - Returns: The MangaDex URL
    static func getCoverUrl(mangaId: String, fileName: String, size: MDCoverSize) -> URL {
        var fullName = fileName
        switch size {
        case .small:
            fullName += ".256.jpg"
        case .medium:
            fullName += ".512.jpg"
        default:
            break
        }
        let baseURL = URL(string: MDApi.uploadsBaseURL)!
        return buildUrl(for: baseURL, with: ["covers", mangaId, fullName])
    }

}
