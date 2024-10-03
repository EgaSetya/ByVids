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
}

extension VideoTargetType: TargetType {
    var baseURL: URL { URL(string: "https://api.cloudinary.com/v1_1/dk3lhojel/")! }
    
    var path: String {
        switch self {
        case .getVideos: "resources/video"
        case .deleteVideo: "resources/video/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVideos: .get
        case .deleteVideo: .delete
        }
    }
    
    var task: Moya.Task {
        .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.default
        )
    }
    
    var headers: [String: String]? {
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
        }
    }
}

