//
//  MDPath.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The class responsible for generating URLs for calls to the website and API
public class MDPath {

    /// Build an absolute URL with the known base and the given path
    /// - Parameter endpoint: The relative path of the resource
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint) -> URL {
        let url = URL(string: MDApi.baseURL)!
        return url.appendingPathComponent(endpoint.rawValue)
    }

    /// Build an absolute URL with the known base and the given `Int` parameters
    /// - Parameter endpoint: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint, with components: [Int]) -> URL {
        var url = URL(string: MDApi.baseURL)!
        url = url.appendingPathComponent(endpoint.rawValue)
        for component in components {
            url = url.appendingPathComponent(String(component))
        }
        return url
    }

    /// Build an absolute URL with the known base and the given `String` parameters
    /// - Parameter endpoint: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint, with components: [String]) -> URL {
        var url = URL(string: MDApi.baseURL)!
        url = url.appendingPathComponent(endpoint.rawValue)
        for component in components {
            url = url.appendingPathComponent(component)
        }
        return url
    }

}
