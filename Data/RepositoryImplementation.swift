//
//  RepositoryImplementation.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Combine

final class DefaultVideoRepository: VideoRepository {
    private let dataSourceFactory = DataSourceFactory()
    
    func getVideos() -> AnyPublisher<VideoResponseEntity, NetworkError> {
        dataSourceFactory.remoteDataSource.request(.getVideos, VideoResponseEntity.self)
    }
}
