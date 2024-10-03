//
//  AddVideoViewModel.swift
//  ByVids
//
//  Created by Ega Setya Putra on 03/10/24.
//

import Combine
import Foundation
import PhotosUI

enum AddVideoViewState: Equatable {
    case idle
    case videoSelected
    case uploading
    case uploaded
    case error(message: String)
    case connectionError(message: String)
}

class AddVideoViewModel: ObservableObject {
    @Published var selectedVideoURL: URL? {
        didSet {
            if let _ = selectedVideoURL {
                viewState = .videoSelected
            }
        }
    }
    @Published var showVideoPicker = false
    @Published var showVideoPlayer = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var viewState: AddVideoViewState = .idle
    
    private var uploadCancellable: Cancellable?
    private let repository = DefaultVideoRepository()
    
    func uploadVideo() {
        viewState = .uploading
        
        if let fileURL = selectedVideoURL {
            uploadCancellable = repository.uploadVideo(fileURL: fileURL)
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
                    self?.viewState = .uploaded
                }
        }
    }
    
    func cancelUpload() {
        repository.cancelRequests()
        uploadCancellable?.cancel()
        
        if let _ = selectedVideoURL {
            viewState = .videoSelected
        } else {
            viewState = .idle
        }
    }
    
    func openGallery() {
        sourceType = .photoLibrary
        showVideoPicker = true
    }
    
    func recordVideo() {
        sourceType = .camera
        showVideoPicker = true
    }
}
