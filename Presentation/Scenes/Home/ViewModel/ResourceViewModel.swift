//
//  ResourceViewModel.swift
//  ByVids
//
//  Created by Ega Setya Putra on 02/10/24.
//

import Foundation

struct ResourceViewModel: Identifiable {
    let resource: Resource
    
    var id: String { resource.assetId }
    var publicID: String { resource.publicId }
    var displayName: String { resource.displayName }
    var videoURL: URL? { URL(string: resource.secureUrl) }
    var thumbnailURL: URL? { URL(string: resource.thumbnailUrl) }
    var previewURL: URL? { URL(string: resource.previewUrl) }
}
