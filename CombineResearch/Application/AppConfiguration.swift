//
//  AppConfiguration.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/03.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let url = Constants.BaseURL.url else {
            fatalError("URL Error")
        }
        return url.absoluteString
    }()
}
