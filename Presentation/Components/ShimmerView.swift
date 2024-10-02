//
//  ShimmerView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct ShimmerView: View {
    let size: CGFloat
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: size, height: size + 30)
                .overlay(
                    LinearGradient(
                        gradient:
                            Gradient(
                                colors: [Color.gray.opacity(0.0001), Color.gray.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .rotationEffect(.degrees(15))
                            .offset(x: phase * size, y: 0)
                    )
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        }
        .cornerRadius(10)
    }
}
