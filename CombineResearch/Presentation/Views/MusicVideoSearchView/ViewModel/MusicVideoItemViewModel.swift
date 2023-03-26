//
//  MusicVideoItemViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2023/03/26.
//

import Foundation

struct MusicVideoItemViewModel {
    let artist: String
    let videoTitle: String
    let videoLength: Int
}

extension MusicVideoItemViewModel {
    init(musicVideo: MusicVideo) {
        self.artist = musicVideo.artistName
        self.videoTitle = musicVideo.trackName
        self.videoLength = musicVideo.trackTimeMillis ?? 0
    }
}
