//
//  MusicVideoCell.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/31.
//

import UIKit

class MusicVideoCell: UITableViewCell {
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoLength: UILabel!
    
    func configure(with viewModel: MusicVideoCell.ViewModel) {
        artist.text = viewModel.artist
        videoTitle.text = viewModel.videoTitle
        videoLength.text = viewModel.videoLength.convertMillisecondsToTimeString()
    }
    
}

extension MusicVideoCell {
    struct ViewModel {
        let artist: String
        let videoTitle: String
        let videoLength: Int
        
        init(musicVideo: MusicVideo) {
            self.artist = musicVideo.artistName
            self.videoTitle = musicVideo.trackName
            self.videoLength = musicVideo.trackTimeMillis ?? 0
        }
    }
}
