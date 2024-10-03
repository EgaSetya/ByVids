//
//  AnimatedGifView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 02/10/24.
//

import SwiftUI

struct AnimatedGifView: UIViewControllerRepresentable {
    @Binding var url: URL
    
    func makeUIViewController(context: Context) -> GifViewController {
        let gifViewController = GifViewController()
        return gifViewController
    }
    
    func updateUIViewController(_ uiViewController: GifViewController, context: Context) {
        uiViewController.loadGif(from: url)
    }
}

class GifViewController: UIViewController {
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = view.bounds
    }
    
    func loadGif(from url: URL) {
        imageView.setGifFromURL(url)
    }
}
