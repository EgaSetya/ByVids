//
//  ContentView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var shouldShowSplash: Bool = true
    
    @ObservedObject private var viewModel: HomepageViewModel
    
    init(viewModel: HomepageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if shouldShowSplash {
                        SplashView()
                    } else {
                        contentView()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    shouldShowSplash = false
                }
            }
            viewModel.loadVideos()
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.viewState {
        case .idle:
            EmptyView()
        case .loading:
            LoadingView(type: .load)
        case .dataRetrieved:
            VideoGridView(viewModel: viewModel) { item in
                coordinator.showVideoPageView(viewModel.getVideoViewModel(by: item))
            } addDidTap: {
                coordinator.showAddViewPageView()
            }

        case .error(let message), .connectionError(let message):
            DialogView(type: .commonError(message: message), mainButtonDidTap: ({
                viewModel.loadVideos()
            }), cancelButtonDidTap: nil)
        }
    }
}

#Preview {
    HomePageView(viewModel: HomepageViewModel(repository: DefaultVideoRepository()))
}
