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
    private let addDidTap: (() -> Void)
    
    init(viewModel: HomepageViewModel, onItemDidTap: @escaping ((_ item: Int) -> Void), addDidTap: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.onItemDidTap = onItemDidTap
        self.addDidTap = addDidTap
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Group {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding([.leading], 5)
                        Text("byvids")
                            .font(.system(size: 25, weight: .semibold, design: .monospaced))
                    }
                    Spacer()
                    Button(action: {
                        addDidTap()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.black.opacity(0.8))
                            .padding([.trailing], 15)
                    })
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
