//
//  MusicVideoRequestDTO.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/29.
//

import Foundation

struct MusicVideoRequestDTO: Encodable {
    let term: String
    let limit: Int
    let offset: Int
    let entity: String
}
