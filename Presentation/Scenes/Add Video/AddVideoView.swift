//
//  AddVideoView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 03/10/24.
//

import SwiftUI
import AVKit

struct AddVideoView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel = AddVideoViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                createContentView(geometry)
            }
            .navigationTitle("Upload Video")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $viewModel.showVideoPicker) {
                VideoPicker(sourceType: viewModel.sourceType, selectedVideoURL: $viewModel.selectedVideoURL)
            }
        }
    }
    
    @ViewBuilder
    func createContentView(_ geometry: GeometryProxy) -> some View {
        switch viewModel.viewState {
        case .idle:
            createEmptyVideoView(geometry)
            createButtonsView(geometry)
        case .videoSelected:
            createVideoPlayerView(geometry)
            createButtonsView(geometry)
        case .uploading:
            createLoadingView()
        case .uploaded:
            createUploadSuccessView()
        case .error(let message):
            DialogView(type: .commonError(message: message), mainButtonDidTap: ({
                viewModel.uploadVideo()
            }), cancelButtonDidTap: nil)
        case .connectionError(let message):
            DialogView(type: .connectionError(message: message), mainButtonDidTap: ({
                viewModel.uploadVideo()
            }), cancelButtonDidTap: nil)
        }
    }
    
    @ViewBuilder
    func createLoadingView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            LoadingView(type: .upload)
            
            Button(action: {
                viewModel.cancelUpload()
            }) {
                HStack {
                    Text("Cancel")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: 200, maxHeight: 50)
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }.padding([.top], -200)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func createVideoPlayerView(_ geometry: GeometryProxy) -> some View {
        if let selectedVideoURL = viewModel.selectedVideoURL {
            VideoPlayer(player: AVPlayer(url: selectedVideoURL))
                .frame(height: geometry.size.height * 0.8)
        }
    }
    
    @ViewBuilder
    func createEmptyVideoView(_ geometry: GeometryProxy) -> some View {
        VStack {
            Image(systemName: "video.slash")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundColor(.gray)
            Text("No Video Selected")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(height: geometry.size.height * 0.8)
    }
    
    @ViewBuilder
    func createButtonsView(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: 10) {
            Button(action: {
#if targetEnvironment(simulator)
                if let url = Bundle.main.url(forResource: "sample", withExtension: "mp4") {
                    viewModel.selectedVideoURL = url
                }
#else
                viewModel.openGallery()
#endif
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                    Text("Gallery")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.075)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding([.leading], 15)
            }
            
            Button(action: {
#if targetEnvironment(simulator)
                if let url = Bundle.main.url(forResource: "sample", withExtension: "mp4") {
                    viewModel.selectedVideoURL = url
                }
#else
                viewModel.recordVideo()
#endif
            }) {
                HStack {
                    Image(systemName: "video")
                        .font(.system(size: 24))
                    Text("Record")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.075)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding([.trailing], 15)
            }
        }
        .frame(maxHeight: geometry.size.height * 0.1)
        
        createUploadButton(geometry)
    }
    
    @ViewBuilder
    func createUploadButton(_ geometry: GeometryProxy) -> some View {
        if viewModel.selectedVideoURL != nil {
            Button(action: {
                viewModel.uploadVideo()
            }) {
                HStack {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.system(size: 24))
                    Text("Upload Video")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.075)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    func createUploadSuccessView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundColor(.green)
            Text("Upload Success")
                .font(.system(size: 20, weight: .medium, design: .monospaced))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                coordinator.showHomePageView()
            }
        }
    }
}

#Preview {
    AddVideoView()
}
