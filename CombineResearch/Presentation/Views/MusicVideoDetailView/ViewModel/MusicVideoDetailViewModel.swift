//
//  MusicVideoDetailViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/04.
//

import Foundation
import Combine

protocol MusicVideoDetailViewModel {
    var artistName: String { get }
    var trackName: String { get }
    var artworkUrl100: String { get }
    var trackTimeMillis: Int? { get }
    var country: String { get }
    var primaryGenreName: String { get }
}

final class DefaultMusicVideoDetailViewModel: MusicVideoDetailViewModel {
    
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    let trackTimeMillis: Int?
    let country: String
    let primaryGenreName: String
    
    init(musicVideo: MusicVideo) {
        self.artistName = musicVideo.artistName
        self.trackName = musicVideo.trackName
        self.artworkUrl100 = musicVideo.artworkUrl100
        self.trackTimeMillis = musicVideo.trackTimeMillis ?? nil
        self.country = musicVideo.country
        self.primaryGenreName = musicVideo.primaryGenreName
    }
    
}
