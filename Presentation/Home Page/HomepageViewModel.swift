//
//  HomepageViewModel.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Combine
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

final class VideoViewModel: ObservableObject {
    // The repository to fetch videos
    private let videoRepository: VideoRepository
    
    // Published properties
    @Published var resources: [ResourceViewModel] = []
    @Published var isLoading: Bool = false // Loading state
    @Published var errorMessage: String?
    
    // Store subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // Initialize the ViewModel with the repository
    init(videoRepository: VideoRepository) {
        self.videoRepository = videoRepository
    }
    
    // Function to load videos
    func loadVideos() {
        // Start loading
        isLoading = true
        
        videoRepository.getVideos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                // Stop loading regardless of success or failure
                self?.isLoading = false
                
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch videos: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data in
                self?.resources = data.resources.compactMap { resource in ResourceViewModel(resource: resource) }
            }
            .store(in: &cancellables)
    }
}
