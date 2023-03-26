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
    
    func configure(with viewModel: MusicVideoItemViewModel) {
        artist.text = viewModel.artist
        videoTitle.text = viewModel.videoTitle
        videoLength.text = viewModel.videoLength.convertMillisecondsToTimeString()
    }
    
}
