//
//  SplashView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 01/10/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Image("SplashScreenBackground")
                .resizable()
            Rectangle()
                .background(Color.black)
                .opacity(0.45)
        }
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea(.all)
        Text("byvids")
            .font(.system(size: 56, weight: .black, design: .rounded))  // Custom font
            .foregroundColor(.white)
            .padding(.bottom, 100)
    }
}
