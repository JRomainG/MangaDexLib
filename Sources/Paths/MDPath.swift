//
//  MDPath.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The class responsible for generating URLs for calls to the website and API
class MDPath {

    /// Build an absolute URL with the given base URL and paths
    /// - Parameter endpoint: The relative path of the resource
    /// - Returns: The MangaDex URL
    static func buildUrl(for baseURL: URL, with components: [String]) -> URL {
        var url = baseURL
        for component in components {
            url = url.appendingPathComponent(String(component))
        }
        return url
    }

    /// Build an absolute URL with the known base and the given parameters
    /// - Parameter endpoint: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint, with components: [LosslessStringConvertible] = []) -> URL {
        let stringComponents = components.map { (component) -> String in
            return String(component.description)
        }
        return buildUrl(for: URL(string: MDApi.baseURL)!, with: [endpoint.rawValue] + stringComponents)
    }

    /// Build an absolute URL with the known base and the given parameters
    /// - Parameter endpoint: The relative path of the resource
    /// - Parameter params: The list of parameters to add to the URL
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint, with params: [URLQueryItem]) -> URL {
        // Use URLComponents to build the string and escape the passed values
        let baseUrl = buildUrl(for: endpoint)
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!

        // Remove keys with empty values
        components.queryItems = []
        for param in params where (param.value != nil && !param.value!.isEmpty) {
            components.queryItems?.append(param)
        }

        // We manually have to escape the "+" for some reason...
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components.url!
    }

}
