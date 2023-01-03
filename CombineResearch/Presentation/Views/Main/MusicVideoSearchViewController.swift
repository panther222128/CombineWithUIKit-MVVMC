//
//  MusicVideoSearchViewController.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit
import Combine

final class MusicVideoSearchViewController: UIViewController {
    
    static let storyboardName = "Main"
    static let storyboardID = "MusicVideoSearchViewController"
    
    @IBOutlet weak var musicVideoSearchBar: UISearchBar!
    @IBOutlet weak var musicVideoListView: UITableView!
    
    private var mainViewModel: MusicVideosViewModel!
    private var cancelBag: Set<AnyCancellable> = Set([])
    private var musicVideoListAdapter: MusicVideoListAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicVideoSearchBar.delegate = self
        musicVideoListAdapter = MusicVideoListAdapter(tableView: musicVideoListView, dataSource: mainViewModel, delegate: self)
        subscribeAlert()
        subscribeMusicVideos()
    }
    
    static func create(with viewModel: MusicVideosViewModel) -> MusicVideoSearchViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? MusicVideoSearchViewController else { return .init() }
        viewController.mainViewModel = viewModel
        return viewController
    }
    
}

// MARK: - Subscribe

extension MusicVideoSearchViewController {
    private func subscribeAlert() {
        mainViewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.alert(with: message)
            }
            .store(in: &cancelBag)
    }
    
    private func subscribeMusicVideos() {
        mainViewModel.musicVideos
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                    
                case .failure(let error):
                    self?.alert(with: error.localizedDescription)
                    
                }
            } receiveValue: { [weak self] _ in
                self?.musicVideoListView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Private

extension MusicVideoSearchViewController {
    private func alert(with message: String) {
        let alert = UIAlertController(title: "Empty", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
}

// MARK: - Delegate

extension MusicVideoSearchViewController: MusicVideoDelegate {
    func selectMusicVideo(at indexPath: IndexPath) {
        
    }
}

extension MusicVideoSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        mainViewModel.didSearch(query: searchText)
    }
}
