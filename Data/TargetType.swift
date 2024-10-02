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
}

extension VideoTargetType: TargetType {
    var baseURL: URL { URL(string: "https://api.cloudinary.com/v1_1/dk3lhojel/")! }
    
    var path: String {
        switch self {
        case .getVideos: "resources/video"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task { .requestParameters(parameters: ["max_results": 30], encoding: URLEncoding.default) }
    
    var headers: [String: String]? {
        let apiKey = "764292367668433"
        let apiSecret = "7joFRwDGPx61FwsII7uEPqqamYE"
        let credentials = "\(apiKey):\(apiSecret)"
        let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        
        return ["Authorization": "Basic \(encodedCredentials)"]
    }
}

