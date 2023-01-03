//
//  Int.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/02.
//

import Foundation

extension Int {
    func convertMillisecondsToTimeString() -> String {
        let minutes = (self / 1000) / 60
        let seconds = (self / 1000) % 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
}
