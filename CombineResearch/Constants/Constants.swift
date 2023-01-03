//
//  Constants.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

struct Constants {
    
    struct TabBarImage {
        static let month = UIImage(named: "30")
        static let week = UIImage(named: "7")
        static let day = UIImage(named: "1")
        static let asset = UIImage(named: "asset")
        static let settings = UIImage(named: "settings")
        static let selectedMonth = UIImage(named: "selected_30")
        static let selectedWeek = UIImage(named: "selected_7")
        static let selectedDay = UIImage(named: "selected_1")
        static let selectedAsset = UIImage(named: "selected_asset")
        static let selectedSettings = UIImage(named: "selected_settings")
    }
    
    struct BaseURL {
        static let url = URL(string: "https://itunes.apple.com/")
    }
    
    // MARK: - To be localized
    
    struct Message {
        static let empty: String = "None"
        static let loadError: String = "Load error"
    }
    
}
