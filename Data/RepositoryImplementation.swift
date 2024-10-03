//
//  RepositoryImplementation.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Combine
import Foundation

final class DefaultVideoRepository: VideoRepository {
    private lazy var dataSourceFactory: DataSourceFactory  = {
        DataSourceFactory()
    }()
    
    func getVideos() -> AnyPublisher<VideoResponseEntity, NetworkError> {
        dataSourceFactory.remoteDataSource.request(.getVideos, VideoResponseEntity.self)
    }
    
    func deleteVideo(publicID: String) -> AnyPublisher<DeleteVideoResponseEntity, NetworkError> {
        dataSourceFactory.remoteDataSource.request(.deleteVideo(publicID: publicID), DeleteVideoResponseEntity.self)
    }
    
    func uploadVideo(fileURL: URL) -> AnyPublisher<UploadVideoResponseEntity, NetworkError> {
        dataSourceFactory.remoteDataSource.request(.uploadVideo(videoURL: fileURL), UploadVideoResponseEntity.self)
    }
    
    func cancelRequests() {
        dataSourceFactory.remoteDataSource.cancelAllRequests()
    }
}
