//
//  UploadVideoResponseEntity.swift
//  ByVids
//
//  Created by Ega Setya Putra on 03/10/24.
//

import Foundation

// MARK: - UploadVideosResponse
struct UploadVideoResponseEntity: Codable {
    let publicId: String
    let video: Video
}

// MARK: - Video
struct Video: Codable {
    let pixFormat, codec: String
    let level: Int
    let profile, bitRate, timeBase: String
}
