//
//  LoadingView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 02/10/24.
//

import SwiftUI

enum LoadingType {
    case load
    case delete
    case upload
    
    var text: String {
        switch self {
        case .load:
            "Loading.."
        case .delete:
            "Deleting.."
        case .upload:
            "Uploading..."
        }
    }
}

struct LoadingView: View {
    var type: LoadingType
    
    var body: some View {
        VStack {
            LottieView(animationName: "loading_indicator_lottie")
                .frame(height: 300, alignment: .center)
                .padding([.top], 150)
            Text(type.text)
                .font(.system(size: 20, weight: .medium, design: .monospaced))
            Spacer()
        }
    }
}
