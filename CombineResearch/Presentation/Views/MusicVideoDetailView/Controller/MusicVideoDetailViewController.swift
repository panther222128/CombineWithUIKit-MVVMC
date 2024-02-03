//
//  MusicVideoDetailViewController.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/04.
//

import UIKit
import Combine

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
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.loadArtworkImage()
            setupViews(with: viewModel)
        }
    }
    
    static func create(with viewModel: MusicVideoDetailViewModel) -> MusicVideoDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? MusicVideoDetailViewController else { return .init() }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func subscribe(error: AnyPublisher<String, Never>) {
        error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.alert(with: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func setupViews(with viewModel: MusicVideoDetailViewModel) {
        trackTimeLabel.text = viewModel.trackTimeMillis?.convertMillisecondsToTimeString()
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        primaryGenreNameLabel.text = viewModel.primaryGenreName
        countryLabel.text = viewModel.country
        artworkImageView.image = UIImage(data: viewModel.artworkImageData ?? Data())
    }
    
    private func alert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
    
}
