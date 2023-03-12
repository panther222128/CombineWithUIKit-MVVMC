//
//  MusicVideoListAdapter.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/31.
//

import UIKit

protocol MusicVideoDataSource: AnyObject {
    func numberOfMusicVideos() -> Int
    func loadMusicVideo(at index: Int) -> MusicVideo
}

protocol MusicVideoDelegate: AnyObject {
    func selectMusicVideo(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

final class MusicVideoListAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var dataSource: MusicVideoDataSource?
    private weak var delegate: MusicVideoDelegate?
    
    init(tableView: UITableView, dataSource: MusicVideoDataSource?, delegate: MusicVideoDelegate?) {
        tableView.register(UINib(nibName: "MusicVideoCell", bundle: .main), forCellReuseIdentifier: "MusicVideoCellID")
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension MusicVideoListAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return .init() }
        return dataSource.numberOfMusicVideos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicVideoCellID", for: indexPath) as? MusicVideoCell else { return .init() }
        guard let dataSource = dataSource else { return .init() }
        cell.configure(with: .init(musicVideo: dataSource.loadMusicVideo(at: indexPath.row)))
        return cell
    }
}

extension MusicVideoListAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectMusicVideo(at: indexPath)
    }
}
