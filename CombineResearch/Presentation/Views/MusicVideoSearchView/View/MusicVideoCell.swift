//
//  MusicVideoCell.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/31.
//

import UIKit

final class MusicVideoCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoLengthLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    func configure(with viewModel: MusicVideoItemViewModel) {
        artistNameLabel.text = viewModel.artistName
        videoTitleLabel.text = viewModel.videoTitle
        videoLengthLabel.text = viewModel.videoLength
        artworkImageView.image = UIImage(data: viewModel.artworkImageData)
    }
    
}
