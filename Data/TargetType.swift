//
//  TargetType.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Foundation

import Moya

enum VideoTargetType {
    case getVideos
    case deleteVideo(publicID: String)
    case uploadVideo(videoURL: URL)
}

extension VideoTargetType: TargetType {
    var baseURL: URL { URL(string: "https://api.cloudinary.com/v1_1/dk3lhojel/")! }
    
    var path: String {
        switch self {
        case .getVideos: "resources/video"
        case .deleteVideo: "resources/video/upload"
        case .uploadVideo: "video/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVideos: .get
        case .deleteVideo: .delete
        case .uploadVideo: .post
        }
    }
    
    var task: Moya.Task {
        if case .uploadVideo(let videoURL) = self {
            let videoData = try! Data(contentsOf: videoURL)
            let formData = MultipartFormData(provider: .data(videoData), name: "file", fileName: videoURL.lastPathComponent, mimeType: "video/quicktime")
            
            let uploadPreset = MultipartFormData(provider: .data("ml_default".data(using: .utf8)!), name: "upload_preset")
            let publicID = MultipartFormData(provider: .data(UUID().uuidString.data(using: .utf8)!), name: "public_id")
            let apiKey = MultipartFormData(provider: .data("<api_key>".data(using: .utf8)!), name: "api_key")
            
            return .uploadMultipart([formData, uploadPreset, publicID, apiKey])
        }
        
        return .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.default
        )
    }
    
    var headers: [String: String]? {
        if case .uploadVideo = self {
            return ["Content-Type": "multipart/form-data"]
        }
        
        let apiKey = "764292367668433"
        let apiSecret = "7joFRwDGPx61FwsII7uEPqqamYE"
        let credentials = "\(apiKey):\(apiSecret)"
        let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        
        return ["Authorization": "Basic \(encodedCredentials)"]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getVideos:
            ["max_results": 30]
        case .deleteVideo(let publicID):
            ["public_ids": publicID]
        default: [:]
        }
    }
}

