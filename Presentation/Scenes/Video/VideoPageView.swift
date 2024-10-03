//
//  VideoPageView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI
import AVKit

struct VideoPageView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var player: AVPlayer? = nil
    @ObservedObject private var viewModel: VideoViewModel
    
    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                contentView()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Video Detail")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        coordinator.showHomePageView()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black.opacity(0.75))
                    }
                }
            }
            .onReceive(viewModel.$viewState) { viewState in
                if viewState == .deleted {
                    coordinator.showHomePageView()
                }
            }
            
            createDeleteConfirmationView()
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        if viewModel.viewState == .idle {
            createPreviewView()
        } else if viewModel.viewState == .playing {
            createVideoPlayerView()
        } else if viewModel.viewState == .deleting {
            LoadingView(type: .delete)
        } else if case let .error(message) = viewModel.viewState {
            DialogView(type: .commonError(message: message), mainButtonDidTap: ({
                viewModel.deleteVideo()
            }), cancelButtonDidTap: nil)
        } else if case let .connectionError(message) = viewModel.viewState {
            DialogView(type: .commonError(message: message), mainButtonDidTap: ({
                viewModel.deleteVideo()
            }), cancelButtonDidTap: nil)
        }
    }
    
    @ViewBuilder
    func createPreviewView() -> some View {
        VStack {
            ZStack {
                if let previewURL = viewModel.itemViewModel.previewURL {
                    AnimatedGifView(url: Binding(get: { previewURL }, set: { _ in }))
                }
                
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                if player == nil {
                    if let videoURL = viewModel.itemViewModel.videoURL {
                        player = AVPlayer(url: videoURL)
                    }
                }
                viewModel.playVideo()
            }
            
            createDeleteButton()
        }
    }
    
    @ViewBuilder
    func createVideoPlayerView() -> some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                    }
            }
            
            createDeleteButton()
        }
    }
    
    @ViewBuilder
    func createDeleteButton() -> some View {
        Button(action: {
            viewModel.showDeleteConfirmation()
        }) {
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(.pink)
                    .frame(width: 15, height: 20)
                    .fontWeight(.black)
                Text("DELETE")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.pink)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func createDeleteConfirmationView() -> some View {
        if viewModel.shouldShowDeleteConfirmation {
            DialogView(type: .deleteValidation) {
                viewModel.deleteVideo()
            } cancelButtonDidTap: {
                viewModel.hideDeleteConfirmation()
            }
            .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    VideoPageView(viewModel:
        VideoViewModel(
            itemViewModel: ResourceViewModel(
                resource:
                    Resource(
                        assetId: "",
                        publicId: "598bf949-0460-48a2-97c0-f2e4ed9c3018",
                        version: 0,
                        bytes: 0,
                        width: 0,
                        height: 0,
                        assetFolder: "",
                        displayName: "",
                        url: "http://res.cloudinary.com/dk3lhojel/video/upload/v1721141061/598bf949-0460-48a2-97c0-f2e4ed9c3018.mp4",
                        secureUrl: "https://res.cloudinary.com/dk3lhojel/video/upload/v1721141061/598bf949-0460-48a2-97c0-f2e4ed9c3018.mp4"
                    )
            ),
            repository: DefaultVideoRepository()
        )
    )
}
