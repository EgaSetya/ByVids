//
//  ContentView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Background to cover the full screen
//            Color.black.opacity(0.5)
//                .ignoresSafeArea()
            
            // Centered ProgressView
            ProgressView("Loading videos...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.7)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
    }
}

struct HomePageView: View {
    @ObservedObject private var viewModel: VideoViewModel
    @State private var shouldShowSplash: Bool = true
    
    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                // TODO: Update if statements with `ViewState` binding
                if shouldShowSplash {
                    SplashView()
                } else {
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        } else {
                            VideoGridView(viewModel: viewModel)
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    shouldShowSplash = false
                    viewModel.loadVideos()
                }
            }
        }
    }
}

#Preview {
    HomePageView(viewModel: VideoViewModel(videoRepository: DefaultVideoRepository()))
}
