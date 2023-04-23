//
//  MusicVideoItemViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2023/03/26.
//

import Foundation

struct MusicVideoItemViewModel {
    let artistName: String
    let videoTitle: String
    let videoLength: Int
}

extension MusicVideoItemViewModel {
    static func from(_ musicVideo: MusicVideo) -> MusicVideoItemViewModel {
        return .init(artistName: musicVideo.artistName, videoTitle: musicVideo.trackName, videoLength: musicVideo.trackTimeMillis ?? 0)
    }
}
