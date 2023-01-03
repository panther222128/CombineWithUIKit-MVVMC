//
//  APIEndpoints.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/29.
//

import Foundation

struct APIEndpoints {
    
    static func getMusicVideo(with musicVideoRequestDTO: MusicVideoRequestDTO) -> Endpoint<MusicVideosResponseDTO> {
        return Endpoint(path: "search", queryParametersEncodable: musicVideoRequestDTO, method: .get)
    }
    
}

