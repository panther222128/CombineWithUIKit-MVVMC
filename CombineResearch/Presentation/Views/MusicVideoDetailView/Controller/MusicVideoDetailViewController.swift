//
//  MusicVideoDetailViewController.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/04.
//

import UIKit

class MusicVideoDetailViewController: UIViewController {

    static let storyboardName = "Main"
    static let storyboardID = "MusicVideoDetailViewController"
    
    @IBOutlet weak var artworkImageView: CachedImageView!
    @IBOutlet weak var trackTimeLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var primaryGenreNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    private var viewModel: MusicVideoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    static func create(with viewModel: MusicVideoDetailViewModel) -> MusicVideoDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? MusicVideoDetailViewController else { return .init() }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func setupViews() {
        trackTimeLabel.text = viewModel.trackTimeMillis?.convertMillisecondsToTimeString()
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        primaryGenreNameLabel.text = viewModel.primaryGenreName
        countryLabel.text = viewModel.country
        artworkImageView.loadImage(with: viewModel.artworkUrl100)
    }
    
}
