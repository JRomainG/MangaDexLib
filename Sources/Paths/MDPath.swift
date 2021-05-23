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

    /// Build a list of URLQueryItems representing an array of strings
    /// - Parameter name: The name of the query item
    /// - Parameter array: The values to encode
    /// - Returns: The list of `URLQueryItem`s representing the array
    static func formatQueryItem(name: String, array: [String]) -> [URLQueryItem] {
        var out: [URLQueryItem] = []
        for i in 0..<array.count {
            out.append(URLQueryItem(name: "\(name)[\(i)]", value: array[i]))
        }
        return out
    }

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

    /// Build an absolute URL with the known base, the given parameters, and additionaly query items
    /// - Parameter endpoint: The relative path of the resource
    /// - Parameter components: The list of integer components to add, seperated by `/`
    /// - Parameter params: The list of query parameters to add to the URL
    /// - Returns: The MangaDex URL
    static func buildUrl(for endpoint: Endpoint,
                         with components: [LosslessStringConvertible] = [],
                         params: [URLQueryItem] = []) -> URL {
        // Build the base URL from the endpoint and components
        let stringComponents = components.map { (component) -> String in
            return String(component.description)
        }
        let baseUrl = buildUrl(for: URL(string: MDApi.apiBaseURL)!, with: [endpoint.rawValue] + stringComponents)

        // Use URLComponents to safely handle the params
        var urlComp = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!

        // Remove keys with empty values
        urlComp.queryItems = []
        for param in params where (param.value != nil && !param.value!.isEmpty) {
            urlComp.queryItems?.append(param)
        }

        // We manually have to escape the "+" for some reason...
        urlComp.percentEncodedQuery = urlComp.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return urlComp.url!
    }

}
