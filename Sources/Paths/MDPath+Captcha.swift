//
//  MDPath+Captcha.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to solve a captcha
    /// - Returns: The MangaDex URL
    public static func solveCaptcha() -> URL {
        return buildUrl(for: .captcha, with: ["solve"])
    }

}
