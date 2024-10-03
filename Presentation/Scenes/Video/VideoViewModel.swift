//
//  VideoViewModel.swift
//  ByVids
//
//  Created by Ega Setya Putra on 02/10/24.
//

import Combine
import Foundation

enum VideoViewState: Equatable {
    case idle
    case playing
    case deleting
    case deleted
    case error(message: String)
    case connectionError(message: String)
}

final class VideoViewModel: ObservableObject {
    @Published var viewState: VideoViewState = .idle
    @Published var shouldShowDeleteConfirmation: Bool = false
    let itemViewModel: ResourceViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: VideoRepository
    
    init(itemViewModel: ResourceViewModel, repository: VideoRepository) {
        self.itemViewModel = itemViewModel
        self.repository = repository
    }
    
    func deleteVideo() {
        hideDeleteConfirmation()
        
        viewState = .deleting
        
        repository.deleteVideo(publicID: itemViewModel.publicID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error == NetworkError.Offline {
                        self?.viewState = .connectionError(message: error.errorDescription ?? "")
                    } else {
                        self?.viewState = .error(message: error.errorDescription ?? "")
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data in
                self?.viewState = .deleted
            }
            .store(in: &cancellables)
    }
    
    func playVideo() {
        viewState = .playing
    }
    
    func showDeleteConfirmation() {
        shouldShowDeleteConfirmation = true
    }
    
    func hideDeleteConfirmation() {
        shouldShowDeleteConfirmation = false
    }
}
