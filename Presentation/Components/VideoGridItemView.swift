//
//  VideoGridItemView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct VideoGridItemView: View {
    private let viewModel: ResourceViewModel
    private let squareSize: CGFloat = 100
    
    init(viewModel: ResourceViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let thumbnailURL = viewModel.thumbnailURL {
                AsyncImage(url: thumbnailURL) { image in
                    ZStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: squareSize, height: squareSize)
                            .clipped()
                        
                        Rectangle()
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .bottom, endPoint: .top)
                            )
                            .opacity(0.55)
                        
                        Image(systemName: "play.fill")
                            .resizable()
                            .foregroundStyle(.thickMaterial)
                            .frame(width: 25, height: 25)
                    }
                } placeholder: {
                    ShimmerView(size: squareSize)
                }
            }
        }
        .frame(width: squareSize, height: squareSize)
        .cornerRadius(10)
    }
}
