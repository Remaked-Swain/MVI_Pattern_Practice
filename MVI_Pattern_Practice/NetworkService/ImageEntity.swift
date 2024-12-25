//
//  ImageEntity.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/24/24.
//

import Foundation

struct ImageEntity: Decodable {
    let id: String
    let author: String
    let width: Double
    let height: Double
    let url: URL?
    let downloadURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
