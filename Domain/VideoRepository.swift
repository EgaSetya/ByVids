//
//  VideoRepository.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Combine
import Foundation

protocol VideoRepository {
    func getVideos() -> AnyPublisher<VideoResponseEntity, NetworkError>
    func deleteVideo(publicID: String) -> AnyPublisher<DeleteVideoResponseEntity, NetworkError>
    func uploadVideo(fileURL: URL) -> AnyPublisher<UploadVideoResponseEntity, NetworkError>
    func cancelRequests()
}
