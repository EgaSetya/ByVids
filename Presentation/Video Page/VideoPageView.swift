//
//  VideoPageView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var isPlaying = false
    @State private var player: AVPlayer? = nil
    private let viewModel: ResourceViewModel
    
    init(viewModel: ResourceViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            if isPlaying {
                if let player = player {
                    VideoPlayer(player: player)
                        .onAppear {
                            player.play()
                        }
                }
            } else {
                ZStack {
                    AnimatedGifView(url: Binding(get: { viewModel.previewURL! }, set: { _ in }))
                    
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    if player == nil {
                        player = AVPlayer(url: viewModel.videoURL!)
                    }
                    isPlaying = true
                }
            }
        }
        .background(Color.black.opacity(0.5))
    }
}
