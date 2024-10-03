//
//  VideosGrid.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct VideoGridView: View {
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: 3)
    
    private let viewModel: HomepageViewModel
    private let onItemDidTap: ((_ item: Int) -> Void)
    
    init(viewModel: HomepageViewModel, onItemDidTap: @escaping ((_ item: Int) -> Void)) {
        self.viewModel = viewModel
        self.onItemDidTap = onItemDidTap
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Group {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .padding([.leading], -25)
                        Text("byvids")
                            .font(.system(size: 32, weight: .semibold, design: .monospaced))
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.resources.enumerated()), id: \.element.id) { item, resourceViewModel in
                        VideoGridItemView(viewModel: resourceViewModel)
                            .onTapGesture {
                                onItemDidTap(item)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .scrollIndicators(.hidden)
    }
}
