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
    let videoLength: String?
    let artworkImageData: Data
}

extension MusicVideoItemViewModel {
    init(musicVideo: MusicVideo, artworkImageData: Data) {
        self.artistName = musicVideo.artistName
        self.videoTitle = musicVideo.trackName
        self.videoLength = musicVideo.trackTimeMillis?.convertMillisecondsToTimeString()
        self.artworkImageData = artworkImageData
    }
}
