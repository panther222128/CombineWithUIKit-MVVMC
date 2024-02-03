//
//  AppConfiguration.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/03.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("URL Error")
        }
        return url
    }()
}
