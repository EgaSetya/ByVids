//
//  HomepageViewModel.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import Combine
import Foundation

enum HomepageViewState: Equatable {
    case idle
    case loading
    case dataRetrieved
    case error(message: String)
    case connectionError(message: String)
}

final class HomepageViewModel: ObservableObject {
    @Published var resources: [ResourceViewModel] = []
    @Published var viewState: HomepageViewState = .idle
    @Published var selectedItem: ResourceViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: VideoRepository
    
    init(repository: VideoRepository) {
        self.repository = repository
    }
    
    func loadVideos() {
        viewState = .loading
        
        repository.getVideos()
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
                self?.resources = data.resources.compactMap { resource in ResourceViewModel(resource: resource) }
                self?.viewState = .dataRetrieved
            }
            .store(in: &cancellables)
    }
    
    func selectItem(_ resourceViewModel: ResourceViewModel) {
        selectedItem = resourceViewModel
    }
    
    func getVideoViewModel(by item: Int) -> VideoViewModel {
        VideoViewModel(itemViewModel: resources[item], repository: repository)
    }
}
