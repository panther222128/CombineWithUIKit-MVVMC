//
//  MusicVideoResponseDTO.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/29.
//

import Foundation

struct MusicVideosResponseDTO: Decodable {
    let resultCount: Int
    let results: [MusicVideoResponseDTO]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

struct MusicVideoResponseDTO: Decodable {
    let wrapperType, kind: String
    let artistID, trackID: Int
    let artistName, trackName, trackCensoredName: String
    let artistViewURL, trackViewURL: String
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String
    let collectionExplicitness, trackExplicitness: String
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName: String

    private enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case trackID = "trackId"
        case artistName, trackName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, trackTimeMillis, country, currency, primaryGenreName
    }
}

extension MusicVideosResponseDTO {
    func toDomain() -> MusicVideos {
        return .init(resultCount: resultCount, results: results.map { $0.toDomain() })
    }
}

extension MusicVideoResponseDTO {
    func toDomain() -> MusicVideo {
        return .init(wrapperType: wrapperType, kind: kind, artistID: artistID, trackID: trackID, artistName: artistName, trackName: trackName, trackCensoredName: trackCensoredName, artistViewURL: artistViewURL, trackViewURL: trackViewURL, previewURL: previewURL ?? "", artworkUrl30: artworkUrl30, artworkUrl60: artworkUrl60, artworkUrl100: artworkUrl100, collectionPrice: collectionPrice, trackPrice: trackPrice, releaseDate: releaseDate, collectionExplicitness: collectionExplicitness, trackExplicitness: trackExplicitness, trackTimeMillis: trackTimeMillis, country: country, currency: currency, primaryGenreName: primaryGenreName)
    }
}
