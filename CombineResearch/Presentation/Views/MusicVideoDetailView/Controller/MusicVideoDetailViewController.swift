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
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackTimeLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var primaryGenreNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    private var viewModel: MusicVideoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(with: viewModel)
    }
    
    static func create(with viewModel: MusicVideoDetailViewModel) -> MusicVideoDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? MusicVideoDetailViewController else { return .init() }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func setupViews(with viewModel: MusicVideoDetailViewModel) {
        trackTimeLabel.text = viewModel.trackTimeMillis?.convertMillisecondsToTimeString()
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        primaryGenreNameLabel.text = viewModel.primaryGenreName
        countryLabel.text = viewModel.country
        if let url = URL(string: viewModel.artworkUrl100) {
            ImageCache.shared.image(for: url.absoluteString) { [weak self] image in
                DispatchQueue.main.async {
                    self?.artworkImageView.image = image
                }
            }
        }
    }
    
}
