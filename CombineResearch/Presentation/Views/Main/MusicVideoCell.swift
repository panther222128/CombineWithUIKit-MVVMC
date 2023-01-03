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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: MusicVideoCell.ViewModel) {
        self.artist.text = viewModel.artist
        self.videoTitle.text = viewModel.videoTitle
        self.videoLength.text = viewModel.videoLength.convertMillisecondsToTimeString()
    }
    
}

extension MusicVideoCell {
    struct ViewModel {
        var artist: String
        var videoTitle: String
        var videoLength: Int
    }
}
