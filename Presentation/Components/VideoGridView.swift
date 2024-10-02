//
//  VideosGrid.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct VideoGridView: View {
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: 3)
    private let viewModel: VideoViewModel
    
    @State private var selectedResourceViewModel: ResourceViewModel?
    
    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.resources) { resourceViewModel in
                    VideoGridItemView(viewModel: resourceViewModel)
                        .onTapGesture {
                            selectedResourceViewModel = resourceViewModel
                        }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .sheet(item: $selectedResourceViewModel, content: { viewModel in
            VideoPlayerView(viewModel: viewModel)
        })
    }
}

