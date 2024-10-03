//
//  Videos.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Foundation

struct VideoResponseEntity: Codable {
    let resources: [Resource]
    let nextCursor: String?
}

struct Resource: Codable {
    let assetId, publicId: String
    let version: Int
    let bytes, width, height: Int
    let assetFolder, displayName: String
    let url: String
    let secureUrl: String
}

extension Resource {
    // TODO: Create url string helper for these
    var thumbnailUrl: String { "https://res.cloudinary.com/dk3lhojel/video/upload/w_150,h_150,c_thumb/\(publicId).jpg" }
    var previewUrl: String { "https://res.cloudinary.com/dk3lhojel/video/upload/f_gif,so_0,du_1,q_1,c_limit,h_150/\(publicId).gif" }
}
