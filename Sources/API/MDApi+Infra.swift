//
//  MDApi+Infra.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {

    /// Ping the MangaDex website to ensure it is up
    /// - Parameter completion: The completion block called once the request is done
    public func ping(completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.ping()
        performGet(url: url) { (response) in
            // Propagate errors
            guard response.error == nil else {
                completion(response.error)
                return
            }
            completion(nil)
        }
    }

}
